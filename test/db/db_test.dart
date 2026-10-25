import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/db/database.dart';

void main() {
  late AppDb db;
  setUp(() => db = AppDb(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('settings round trip', () async {
    await db.setSetting('a', {'x': 1});
    expect(await db.getSetting<Map>('a'), {'x': 1});
    await db.setSetting('a', 5);
    expect(await db.getSetting<int>('a'), 5);
    expect(await db.getSetting<int>('missing'), null);
  });

  test('goal + stage + todo round trip', () async {
    await db.into(db.goals).insert(GoalsCompanion.insert(
        id: 'g1', title: 'T', startAt: 0, deadlineAt: 100, color: 0xFF7B6CF6, createdAt: 0, updatedAt: 0));
    await db.into(db.stages).insert(StagesCompanion.insert(id: 's1', goalId: 'g1', title: 'S', dueAt: 50, createdAt: 0));
    await db.into(db.todos).insert(TodosCompanion.insert(id: 't1', title: 'Todo', normHash: 'h', createdAt: 0, score: const Value(77)));
    final g = await db.select(db.goals).getSingle();
    expect(g.status, 'active');
    expect(g.digestStale, true);
    expect((await db.select(db.todos).getSingle()).score, 77);
    expect((await db.select(db.stages).getSingle()).weight, 20);
  });

  test('export json is encodable', () async {
    await db.log('sync', 'hello', data: {'a': 1});
    final e = await db.exportAll();
    expect(jsonEncode(e), contains('hello'));
    expect((e['tables'] as Map).length, 19);
  });
}
