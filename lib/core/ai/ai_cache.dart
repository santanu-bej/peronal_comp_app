import 'dart:convert';
import 'package:drift/drift.dart';
import '../db/database.dart';
import '../utils/hash.dart';

const _day = 86400000;

class AiCacheStore {
  final AppDb db;
  AiCacheStore(this.db);

  static String key(String feature, String model, String system, String user) => sha256Hex('$feature$model$system$user');

  Future<Map<String, dynamic>?> get(String k, {int? nowMs}) async {
    final row = await (db.select(db.aiCache)..where((c) => c.key.equals(k))).getSingleOrNull();
    if (row == null) return null;
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    if (row.expiresAt != null && row.expiresAt! < now) return null;
    return jsonDecode(row.responseJson) as Map<String, dynamic>;
  }

  Future<void> put(String k, String kind, Map<String, dynamic> value, {int? ttlDays, int? nowMs}) {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    return db.into(db.aiCache).insertOnConflictUpdate(AiCacheCompanion.insert(
      key: k,
      kind: kind,
      responseJson: jsonEncode(value),
      createdAt: now,
      expiresAt: Value(ttlDays == null ? null : now + ttlDays * _day),
    ));
  }

  Future<int> purge({int? nowMs}) {
    final cutoff = (nowMs ?? DateTime.now().millisecondsSinceEpoch) - 180 * _day;
    return (db.delete(db.aiCache)..where((c) => c.createdAt.isSmallerThanValue(cutoff))).go();
  }
}
