import 'dart:typed_data';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/db/database.dart';
import 'package:goal_compass/core/native/secrets.dart';
import 'package:goal_compass/core/services/backup_service.dart';

void main() {
  test('encrypt → decrypt → restore round trip, wrong pass fails', () async {
    final src = AppDb(NativeDatabase.memory());
    await src.setSetting('user.name', 'Santanu');
    await src.into(src.goals).insert(GoalsCompanion.insert(
        id: 'g', title: 'Goal ₹', startAt: 1, deadlineAt: 2, color: 5, createdAt: 1, updatedAt: 1));
    await src.into(src.moneyEntries).insert(MoneyEntriesCompanion.insert(id: 'm', date: 1, amountPaise: 12345, kind: 'saving'));
    final bs = BackupService(src, Secrets());
    final bytes = await bs.encrypt(await bs.snapshotJson(), 'hunter2');

    final dst = AppDb(NativeDatabase.memory());
    await dst.into(dst.goals).insert(GoalsCompanion.insert(
        id: 'old', title: 'Old', startAt: 1, deadlineAt: 2, color: 5, createdAt: 1, updatedAt: 1));
    final bd = BackupService(dst, Secrets());
    expect(() => bd.importFile(bytes, 'nope'), throwsA(isA<BackupException>()));
    expect(() => bd.importFile(Uint8List.fromList([1, 2, 3]), 'x'), throwsA(isA<BackupException>()));
    await bd.importFile(bytes, 'hunter2');

    final goals = await dst.select(dst.goals).get();
    expect(goals.single.title, 'Goal ₹');
    expect(goals.single.digestStale, true);
    expect((await dst.select(dst.moneyEntries).getSingle()).amountPaise, 12345);
    expect(await dst.getSetting<String>('user.name'), 'Santanu');
    await src.close();
    await dst.close();
  }, timeout: const Timeout(Duration(seconds: 60)));
}
