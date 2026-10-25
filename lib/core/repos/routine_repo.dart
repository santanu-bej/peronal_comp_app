import 'dart:convert';
import 'package:drift/drift.dart';
import '../db/database.dart';
import '../native/native_models.dart';
import 'goal_repo.dart';

class WakeConfig {
  final String proof; // walk | type | maths
  final int graceMin, snoozeMax;
  final String sound, message, channel; // channel: whatsapp | sms | both
  final bool vibrate;
  const WakeConfig({
    this.proof = 'walk',
    this.graceMin = 10,
    this.snoozeMax = 1,
    this.sound = 'default',
    this.vibrate = true,
    this.message = defaultWakeMessage,
    this.channel = 'both',
  });

  factory WakeConfig.fromJson(String s) {
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return WakeConfig(
        proof: m['proof'] as String? ?? 'walk',
        graceMin: m['graceMin'] as int? ?? 10,
        snoozeMax: m['snoozeMax'] as int? ?? 1,
        sound: m['sound'] as String? ?? 'default',
        vibrate: m['vibrate'] as bool? ?? true,
        message: m['message'] as String? ?? defaultWakeMessage,
        channel: m['channel'] as String? ?? 'both',
      );
    } catch (_) {
      return const WakeConfig();
    }
  }

  String toJson() => jsonEncode({
        'proof': proof, 'graceMin': graceMin, 'snoozeMax': snoozeMax, 'sound': sound,
        'vibrate': vibrate, 'message': message, 'channel': channel,
      });

  WakeConfig copyWith({String? proof, int? graceMin, int? snoozeMax, String? sound, bool? vibrate, String? message, String? channel}) =>
      WakeConfig(
        proof: proof ?? this.proof,
        graceMin: graceMin ?? this.graceMin,
        snoozeMax: snoozeMax ?? this.snoozeMax,
        sound: sound ?? this.sound,
        vibrate: vibrate ?? this.vibrate,
        message: message ?? this.message,
        channel: channel ?? this.channel,
      );
}

const defaultWakeMessage =
    'Hey {contact}, {user} is still sleeping ({minutes} min after his alarm). He has "{top_task}" pending today. Please call him and wake him up!';

class RoutineRepo {
  final AppDb db;
  RoutineRepo(this.db);

  Stream<List<Routine>> watchAll() => db.select(db.routines).watch();
  Stream<List<Contact>> watchContacts() => db.select(db.contacts).watch();

  Future<Routine> ensureWake() async {
    final r = await (db.select(db.routines)..where((r) => r.kind.equals('wake'))).getSingleOrNull();
    if (r != null) return r;
    final id = newId();
    await db.into(db.routines).insert(RoutinesCompanion.insert(
        id: id, kind: 'wake', title: 'Wake up', configJson: Value(const WakeConfig().toJson())));
    return (db.select(db.routines)..where((x) => x.id.equals(id))).getSingle();
  }

  Future<void> save(String id, {String? time, int? daysMask, bool? enabled, WakeConfig? config}) =>
      (db.update(db.routines)..where((r) => r.id.equals(id))).write(RoutinesCompanion(
        timeHhmm: time == null ? const Value.absent() : Value(time),
        daysMask: daysMask == null ? const Value.absent() : Value(daysMask),
        enabled: enabled == null ? const Value.absent() : Value(enabled),
        configJson: config == null ? const Value.absent() : Value(config.toJson()),
      ));

  Future<void> addContact(String name, String phone, String channel) async {
    final count = (await db.select(db.contacts).get()).length;
    if (count >= 3) return;
    await db.into(db.contacts).insert(ContactsCompanion.insert(id: newId(), name: name.trim(), phoneE164: normalisePhone(phone), channel: Value(channel)));
  }

  Future<void> deleteContact(String id) => (db.delete(db.contacts)..where((c) => c.id.equals(id))).go();

  Future<List<WakeItem>> wakeItems() async {
    final rs = await (db.select(db.routines)..where((r) => r.kind.equals('wake'))).get();
    final contacts = await db.select(db.contacts).get();
    return [
      for (final r in rs)
        () {
          final c = WakeConfig.fromJson(r.configJson);
          return WakeItem(
            id: r.id,
            hhmm: r.timeHhmm,
            daysMask: r.daysMask,
            proof: c.proof,
            graceMin: c.graceMin,
            snoozeMax: c.snoozeMax,
            sound: c.sound,
            vibrate: c.vibrate,
            enabled: r.enabled,
            message: c.message,
            channel: c.channel,
            contacts: [for (final x in contacts) WakeContact(x.name, x.phoneE164, x.channel)],
          );
        }()
    ];
  }
}

/// +91 default for 10-digit Indian numbers; keeps an explicit +country code.
String normalisePhone(String s) {
  final d = s.replaceAll(RegExp(r'[^\d+]'), '');
  if (d.startsWith('+')) return d;
  if (d.length == 10) return '+91$d';
  if (d.startsWith('91') && d.length == 12) return '+$d';
  return d.startsWith('0') ? '+91${d.substring(1)}' : '+$d';
}
