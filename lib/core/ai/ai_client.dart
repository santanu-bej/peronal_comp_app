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

/// Gemini free-tier models. Flash for the two user-facing planning calls, Flash-Lite for the small ones.
const defaultModels = {
  'plan': 'gemini-2.5-flash',
  'digest': 'gemini-2.5-flash-lite',
  'align': 'gemini-2.5-flash-lite',
  'replan': 'gemini-2.5-flash',
  'classify': 'gemini-2.5-flash-lite',
  'review': 'gemini-2.5-flash-lite',
};

const _base = 'https://generativelanguage.googleapis.com/v1beta/models';

/// Gemini's responseSchema is an OpenAPI subset: drop unsupported keys, turn ["x","null"] into nullable.
Map<String, dynamic> toGeminiSchema(Map<String, dynamic> s) {
  const keep = {'type', 'properties', 'required', 'items', 'enum', 'description', 'minItems', 'maxItems', 'minimum', 'maximum', 'nullable'};
  final out = <String, dynamic>{};
  s.forEach((k, v) {
    if (!keep.contains(k)) return;
    if (k == 'type' && v is List) {
      final types = v.where((t) => t != 'null').toList();
      out['type'] = types.first;
      if (v.contains('null')) out['nullable'] = true;
    } else if (k == 'properties') {
      out[k] = (v as Map).map((pk, pv) => MapEntry(pk as String, toGeminiSchema(Map<String, dynamic>.from(pv as Map))));
    } else if (k == 'items') {
      out[k] = toGeminiSchema(Map<String, dynamic>.from(v as Map));
    } else {
      out[k] = v;
    }
  });
  return out;
}

/// Per-feature cache TTL in days. null = never cached.
const _cacheTtl = <String, int?>{'align': 180, 'classify': 180, 'digest': 3650, 'review': 7};

/// The only file that talks to the AI API (Google Gemini).
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
      throw const AiException('AI is off. Add a Gemini key in Settings → AI.');
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

    final isFlash = model.contains('flash');
    final body = jsonEncode({
      'systemInstruction': {
        'parts': [
          {'text': system}
        ]
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': userContent}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'maxOutputTokens': maxTokens,
        'responseMimeType': 'application/json',
        'responseSchema': toGeminiSchema(Map<String, dynamic>.from(tool['input_schema'] as Map)),
        // no hidden "thinking" tokens on Flash models: keeps the token budget honest
        if (isFlash) 'thinkingConfig': {'thinkingBudget': 0},
      },
    });

    http.Response res;
    try {
      res = await _post(key, model, body, timeout);
    } on TimeoutException {
      throw const AiException('The AI took too long. Tap retry.', retryable: true);
    } on http.ClientException {
      throw const AiException('No internet. Your input is kept. Tap retry.', retryable: true);
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiException('No internet or request failed. Tap retry.', retryable: true);
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final u = (json['usageMetadata'] as Map?) ?? {};
    final usage = AiUsageInfo(
      (u['promptTokenCount'] ?? 0) as int,
      ((u['candidatesTokenCount'] ?? 0) as int) + ((u['thoughtsTokenCount'] ?? 0) as int),
      (u['cachedContentTokenCount'] ?? 0) as int,
      0,
    );
    await _recordUsage(feature, model, usage);

    final cands = (json['candidates'] as List?) ?? [];
    final cand = cands.isEmpty ? null : cands.first as Map;
    final parts = ((cand?['content'] as Map?)?['parts'] as List?) ?? [];
    final text = parts.whereType<Map>().map((p) => p['text']).whereType<String>().join();
    if (text.isEmpty) {
      throw const AiException('The AI returned no result. Tap retry.', retryable: true);
    }
    Map<String, dynamic> input;
    try {
      input = Map<String, dynamic>.from(jsonDecode(text) as Map);
    } catch (_) {
      throw const AiException('The AI reply was cut off. Tap retry.', retryable: true);
    }
    final truncated = cand?['finishReason'] == 'MAX_TOKENS';
    final value = parse(input);
    if (ttl != null && !truncated) await cache.put(ck, feature, input, ttlDays: ttl);
    return AiResult(value, usage, truncated: truncated);
  }

  Future<http.Response> _post(String key, String model, String body, Duration timeout) async {
    for (var attempt = 0;; attempt++) {
      final res = await _http
          .post(
            Uri.parse('$_base/$model:generateContent'),
            headers: {'x-goog-api-key': key, 'content-type': 'application/json'},
            body: body,
          )
          .timeout(timeout);
      final code = res.statusCode;
      if (code == 200) return res;
      final bad = res.body.contains('API_KEY_INVALID') || res.body.contains('API key not valid');
      if (code == 401 || code == 403 || (code == 400 && bad)) {
        throw const AiException('Gemini key rejected. Check it in Settings → AI.', keyRejected: true);
      }
      if (code == 400 || code == 404) {
        await db.log('ai', 'AI request invalid ($code)', level: 'error', data: {'body': res.body.length > 500 ? res.body.substring(0, 500) : res.body});
        throw AiException(code == 404 ? 'Model not found. Check the model id in Settings → AI.' : 'AI request invalid.');
      }
      if ((code == 429 || code >= 500) && attempt == 0) {
        await _sleep(Duration(milliseconds: 2000 + _rng.nextInt(2000)));
        continue;
      }
      throw AiException(code == 429 ? 'Free quota used up for now. Try again in a minute.' : 'The AI is busy ($code). Tap retry.', retryable: true);
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

  /// Validates key and model with a metadata GET: costs no tokens.
  Future<String?> testKey(String key, {String? model}) async {
    final m = model ?? defaultModels['digest']!;
    try {
      final res = await _http.get(Uri.parse('$_base/$m'), headers: {'x-goog-api-key': key}).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) return null;
      if (res.statusCode == 404) return 'Model id rejected: $m.';
      if (res.statusCode == 429) return 'Rate limited. Key looks fine, try again in a minute.';
      if (res.statusCode == 400 || res.statusCode == 401 || res.statusCode == 403) return 'Gemini key rejected.';
      return 'Error ${res.statusCode}: ${res.body.length > 160 ? res.body.substring(0, 160) : res.body}';
    } catch (_) {
      return 'No internet.';
    }
  }
}
