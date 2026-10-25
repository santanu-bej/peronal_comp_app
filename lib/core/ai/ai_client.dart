import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart' show Value;
import 'package:http/http.dart' as http;
import '../db/database.dart';
import 'ai_cache.dart';
import 'token_budget.dart';

class AiException implements Exception {
  final String message;
  final bool retryable;
  final bool keyRejected;
  final bool needsConfirm;
  const AiException(this.message, {this.retryable = false, this.keyRejected = false, this.needsConfirm = false});
  @override
  String toString() => message;
}

class AiUsageInfo {
  final int input, output, cacheRead, cacheWrite;
  const AiUsageInfo(this.input, this.output, this.cacheRead, this.cacheWrite);
  int get total => input + output + cacheWrite;
}

class AiResult<T> {
  final T value;
  final AiUsageInfo usage;
  final bool fromCache;
  final bool truncated;
  const AiResult(this.value, this.usage, {this.fromCache = false, this.truncated = false});
}

const defaultModels = {
  'plan': 'claude-sonnet-5-5',
  'digest': 'claude-haiku-5-5',
  'align': 'claude-haiku-5-5',
  'replan': 'claude-sonnet-5-5',
  'classify': 'claude-haiku-5-5',
  'review': 'claude-haiku-5-5',
};

/// Per-feature cache TTL in days. null = never cached.
const _cacheTtl = <String, int?>{'align': 180, 'classify': 180, 'digest': 3650, 'review': 7};

/// The only file that talks to the Claude API.
class AiClient {
  final AppDb db;
  final http.Client _http;
  final Future<String?> Function() keyProvider;
  final TokenBudget budget;
  final AiCacheStore cache;
  final Future<void> Function(Duration) _sleep;
  final Random _rng;

  AiClient({
    required this.db,
    required http.Client client,
    required this.keyProvider,
    Future<void> Function(Duration)? sleep,
    Random? rng,
  })  : _http = client,
        budget = TokenBudget(db),
        cache = AiCacheStore(db),
        _sleep = sleep ?? Future.delayed,
        _rng = rng ?? Random();

  Future<bool> isEnabled() async {
    if ((await db.getSetting<bool>('ai.off')) == true) return false;
    final k = await keyProvider();
    return k != null && k.isNotEmpty;
  }

  Future<String> modelFor(String feature) async =>
      (await db.getSetting<String>('ai.model.$feature')) ?? defaultModels[feature]!;

  Future<AiResult<T>> callTool<T>({
    required String feature,
    required String model,
    required String system,
    required String userContent,
    required Map<String, dynamic> tool,
    required int maxTokens,
    required T Function(Map<String, dynamic>) parse,
    bool cacheSystem = false,
    Duration timeout = const Duration(seconds: 30),
    bool confirmed = false,
    int estimateInput = 600,
  }) async {
    final key = await keyProvider();
    if ((await db.getSetting<bool>('ai.off')) == true || key == null || key.isEmpty) {
      throw const AiException('AI is off. Add a Claude key in Settings → AI.');
    }

    final ttl = _cacheTtl[feature];
    final ck = AiCacheStore.key(feature, model, system, userContent);
    if (ttl != null) {
      final hit = await cache.get(ck);
      if (hit != null) return AiResult(parse(hit), const AiUsageInfo(0, 0, 0, 0), fromCache: true);
    }

    if (!confirmed) {
      final d = await budget.canSpend(feature, estimateInput + maxTokens);
      if (d == BudgetDecision.blocked) {
        throw const AiException('Monthly AI budget reached. Raise it in Settings → AI.');
      }
      if (d == BudgetDecision.needsConfirm) {
        throw const AiException('This call goes over your monthly AI budget.', needsConfirm: true);
      }
    }

    final body = jsonEncode({
      'model': model,
      'max_tokens': maxTokens,
      'temperature': 0.2,
      'system': [
        {'type': 'text', 'text': system, if (cacheSystem) 'cache_control': {'type': 'ephemeral'}}
      ],
      'tools': [tool],
      'tool_choice': {'type': 'tool', 'name': tool['name']},
      'messages': [
        {'role': 'user', 'content': userContent}
      ],
    });

    http.Response res;
    try {
      res = await _post(key, body, timeout);
    } on TimeoutException {
      throw const AiException('Claude took too long. Tap retry.', retryable: true);
    } on http.ClientException {
      throw const AiException('No internet. Your input is kept. Tap retry.', retryable: true);
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiException('No internet or request failed. Tap retry.', retryable: true);
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final u = (json['usage'] as Map?) ?? {};
    final usage = AiUsageInfo(
      (u['input_tokens'] ?? 0) as int,
      (u['output_tokens'] ?? 0) as int,
      (u['cache_read_input_tokens'] ?? 0) as int,
      (u['cache_creation_input_tokens'] ?? 0) as int,
    );
    await _recordUsage(feature, model, usage);

    final blocks = (json['content'] as List?) ?? [];
    final block = blocks.cast<Map>().firstWhere((b) => b['type'] == 'tool_use', orElse: () => {});
    if (block.isEmpty) {
      throw const AiException('Claude returned no result. Tap retry.', retryable: true);
    }
    final input = Map<String, dynamic>.from(block['input'] as Map);
    final truncated = json['stop_reason'] == 'max_tokens';
    final value = parse(input);
    if (ttl != null && !truncated) await cache.put(ck, feature, input, ttlDays: ttl);
    return AiResult(value, usage, truncated: truncated);
  }

  Future<http.Response> _post(String key, String body, Duration timeout) async {
    for (var attempt = 0;; attempt++) {
      final res = await _http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {'x-api-key': key, 'anthropic-version': '2023-06-01', 'content-type': 'application/json'},
            body: body,
          )
          .timeout(timeout);
      final code = res.statusCode;
      if (code == 200) return res;
      if (code == 401) {
        throw const AiException('Claude key rejected. Check it in Settings → AI.', keyRejected: true);
      }
      if (code == 400 || code == 404) {
        await db.log('ai', 'AI request invalid ($code)', level: 'error', data: {'body': res.body.length > 500 ? res.body.substring(0, 500) : res.body});
        throw AiException(code == 404 ? 'Model not found. Check the model id in Settings → AI.' : 'AI request invalid.');
      }
      if ((code == 429 || code == 529 || code >= 500) && attempt == 0) {
        await _sleep(Duration(milliseconds: 2000 + _rng.nextInt(2000)));
        continue;
      }
      throw AiException('Claude is busy ($code). Tap retry.', retryable: true);
    }
  }

  Future<void> _recordUsage(String feature, String model, AiUsageInfo u) => db.into(db.aiUsage).insert(AiUsageCompanion.insert(
        at: DateTime.now().millisecondsSinceEpoch,
        feature: feature,
        model: model,
        inputTokens: Value(u.input),
        outputTokens: Value(u.output),
        cacheReadTokens: Value(u.cacheRead),
        cacheWriteTokens: Value(u.cacheWrite),
      ));

  /// Cheapest possible call to validate a key/model (Haiku, max_tokens 1).
  Future<String?> testKey(String key, {String? model}) async {
    try {
      final res = await _http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {'x-api-key': key, 'anthropic-version': '2023-06-01', 'content-type': 'application/json'},
            body: jsonEncode({
              'model': model ?? defaultModels['digest'],
              'max_tokens': 1,
              'messages': [
                {'role': 'user', 'content': 'hi'}
              ],
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) return null;
      if (res.statusCode == 401) return 'Claude key rejected.';
      if (res.statusCode == 404) return 'Model id rejected: ${model ?? defaultModels['digest']}.';
      return 'Error ${res.statusCode}: ${res.body.length > 160 ? res.body.substring(0, 160) : res.body}';
    } catch (_) {
      return 'No internet.';
    }
  }
}
