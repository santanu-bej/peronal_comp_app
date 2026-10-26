import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API keys live here only (never in the DB, logs or backups).
class Secrets {
  final FlutterSecureStorage _s;
  Secrets([FlutterSecureStorage? s]) : _s = s ?? const FlutterSecureStorage();

  Future<String?> _read(String k) async {
    try {
      return await _s.read(key: k);
    } catch (_) {
      return null;
    }
  }

  Future<String?> aiKey() => _read('ai_key');
  Future<void> setAiKey(String? v) => v == null || v.isEmpty ? _s.delete(key: 'ai_key') : _s.write(key: 'ai_key', value: v.trim());
  Future<String?> whatsappToken() => _read('wa_token');
  Future<void> setWhatsappToken(String? v) => v == null || v.isEmpty ? _s.delete(key: 'wa_token') : _s.write(key: 'wa_token', value: v.trim());
  Future<String?> backupKey() => _read('snapshot_key');
  Future<void> setBackupKey(String v) => _s.write(key: 'snapshot_key', value: v);
}
