class NativeStatus {
  final bool accessibilityOn, usageAccess, notifications, exactAlarm, fullScreenIntent, batteryUnrestricted, smsPermission, activityRecognition;
  final String brand;
  final int sdk;
  const NativeStatus({
    this.accessibilityOn = false,
    this.usageAccess = false,
    this.notifications = false,
    this.exactAlarm = false,
    this.fullScreenIntent = false,
    this.batteryUnrestricted = false,
    this.smsPermission = false,
    this.activityRecognition = false,
    this.brand = '',
    this.sdk = 0,
  });

  factory NativeStatus.fromMap(Map m) => NativeStatus(
        accessibilityOn: m['accessibility'] == true,
        usageAccess: m['usageAccess'] == true,
        notifications: m['notifications'] == true,
        exactAlarm: m['exactAlarm'] == true,
        fullScreenIntent: m['fullScreenIntent'] == true,
        batteryUnrestricted: m['battery'] == true,
        smsPermission: m['sms'] == true,
        activityRecognition: m['activityRecognition'] == true,
        brand: (m['brand'] as String?) ?? '',
        sdk: (m['sdk'] as int?) ?? 0,
      );

  bool get needsAutostartTip => const ['xiaomi', 'redmi', 'poco', 'realme', 'oppo', 'vivo', 'oneplus'].contains(brand.toLowerCase());
}

class AlertItem {
  final String id, title, body, kind, deepLink;
  final int atMs;
  const AlertItem({required this.id, required this.atMs, required this.title, required this.body, required this.kind, required this.deepLink});
  Map<String, Object?> toMap() => {'id': id, 'atMs': atMs, 'title': title, 'body': body, 'kind': kind, 'deepLink': deepLink};
}

class WakeContact {
  final String name, phone, channel;
  const WakeContact(this.name, this.phone, this.channel);
  Map<String, Object?> toMap() => {'name': name, 'phone': phone, 'channel': channel};
}

class WakeItem {
  final String id, hhmm, proof, sound, message, channel;
  final int daysMask, graceMin, snoozeMax;
  final bool vibrate;
  final bool enabled;
  final List<WakeContact> contacts;
  const WakeItem({
    required this.id,
    required this.hhmm,
    required this.daysMask,
    required this.proof,
    required this.graceMin,
    required this.snoozeMax,
    required this.sound,
    required this.vibrate,
    this.enabled = true,
    required this.message,
    required this.contacts,
    required this.channel,
  });
  Map<String, Object?> toMap() => {
        'id': id, 'hhmm': hhmm, 'daysMask': daysMask, 'proof': proof, 'graceMin': graceMin, 'snoozeMax': snoozeMax,
        'sound': sound, 'vibrate': vibrate, 'enabled': enabled, 'message': message, 'channel': channel,
        'contacts': [for (final c in contacts) c.toMap()],
      };
}

class TopTask {
  final String id, title;
  final int score;
  const TopTask(this.id, this.title, this.score);
  Map<String, Object?> toMap() => {'id': id, 'title': title, 'score': score};
}

class UsageEvent {
  final String pkg;
  final int start, end;
  const UsageEvent(this.pkg, this.start, this.end);
}
