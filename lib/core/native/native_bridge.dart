import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'native_models.dart';

/// The only file that uses MethodChannels. Every method degrades to a no-op when the platform
/// side is missing (tests, hot-restart), so Dart code never needs try/catch around it.
class NativeBridge {
  static const _m = MethodChannel('goalcompass/native');
  static const _e = EventChannel('goalcompass/events');
  static final _routes = StreamController<String>.broadcast();

  /// goalcompass://… links opened while the app is already running.
  static Stream<String> get routes {
    _m.setMethodCallHandler((call) async {
      if (call.method == 'navigate') _routes.add(call.arguments as String);
    });
    return _routes.stream;
  }

  Future<T?> _call<T>(String method, [Object? args]) async {
    try {
      return await _m.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<NativeStatus> status() async {
    final r = await _call<Map>('status');
    return r == null ? const NativeStatus() : NativeStatus.fromMap(r);
  }

  /// accessibility, usage_access, app_info, battery, exact_alarm, full_screen_intent, notifications
  Future<void> open(String setting) => _call('open', {'setting': setting});

  Future<void> requestRuntime(String permission) => _call('requestRuntime', {'permission': permission});

  Future<void> syncAlerts(List<AlertItem> list) => _call('syncAlerts', jsonEncode([for (final a in list) a.toMap()]));
  Future<void> syncWake(List<WakeItem> list) => _call('syncWake', jsonEncode([for (final w in list) w.toMap()]));
  Future<void> setGuardConfig(Map<String, Object?> json) => _call('setGuardConfig', jsonEncode(json));
  Future<void> setTopTasks(List<TopTask> list) => _call('setTopTasks', jsonEncode([for (final t in list) t.toMap()]));
  Future<void> setSecrets({String? whatsappToken, String? phoneNumberId, String? template, String? lang, String? graphVersion}) =>
      _call('setSecrets', {
        'whatsappToken': whatsappToken,
        'phoneNumberId': phoneNumberId,
        'template': template,
        'lang': lang,
        'graphVersion': graphVersion,
      });

  Future<List<UsageEvent>> readUsage(int fromMs, int toMs) async {
    final r = await _call<String>('readUsage', {'from': fromMs, 'to': toMs});
    if (r == null) return const [];
    return [
      for (final x in jsonDecode(r) as List) UsageEvent(x['pkg'] as String, (x['start'] as num).toInt(), (x['end'] as num).toInt())
    ];
  }

  Future<List<Map<String, dynamic>>> drainEvents() async {
    final r = await _call<String>('drainEvents');
    if (r == null || r.isEmpty) return const [];
    return [for (final x in jsonDecode(r) as List) Map<String, dynamic>.from(x as Map)];
  }

  Future<void> wakeProofDone(String routineId) => _call('wakeProofDone', {'id': routineId});
  Future<void> wakeSnooze(String routineId) => _call('wakeSnooze', {'id': routineId});
  Future<int> wakeSteps() async => (await _call<int>('wakeSteps')) ?? 0;
  Future<Map?> wakeState() => _call<Map>('wakeState');
  Future<void> testEscalation(String routineId) => _call('testEscalation', {'id': routineId});
  Future<void> testAlert(int seconds) => _call('testAlert', {'seconds': seconds});
  Future<void> testNudge() => _call('testNudge');
  Future<void> startFocusNotification(bool on, {String? title}) => _call('focusNotification', {'on': on, 'title': title});
  Future<String?> initialRoute() => _call<String>('initialRoute');
  Future<int> batteryStepCount() async => (await _call<int>('stepCounter')) ?? 0;

  /// Native→Dart events while the app is open.
  Stream<Map<String, dynamic>> events() {
    return _e.receiveBroadcastStream().map((e) => Map<String, dynamic>.from(e as Map)).handleError((_) {});
  }
}
