import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/native/native_models.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/screen.dart';

/// Setup checklist: each row has a status chip and a Fix button. Rechecks when the app resumes.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});
  @override
  ConsumerState<SetupScreen> createState() => _S();
}

class _S extends ConsumerState<SetupScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) ref.invalidate(nativeStatusProvider);
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(nativeStatusProvider).value ?? const NativeStatus();
    final bridge = ref.read(bridgeProvider);
    final aiReady = ref.watch(aiReadyProvider).value ?? false;
    final hc = ref.watch(settingProvider('health.granted')).value == true;

    Future<void> runtime(Permission p) async {
      await p.request();
      ref.invalidate(nativeStatusProvider);
    }

    final rows = <(String, String, bool, VoidCallback, String?)>[
      ('Claude API key', 'Optional. The app works without AI.', aiReady, () => context.push('/settings'), null),
      ('Notifications', 'Reminders and nudges', st.notifications, () => runtime(Permission.notification), null),
      ('Exact alarms', 'Wake alarm and reminders on the minute', st.exactAlarm, () => bridge.open('exact_alarm'), null),
      ('Full-screen alerts', 'Wake screen over the lock screen', st.fullScreenIntent, () => bridge.open('full_screen_intent'), null),
      ('Accessibility service', 'Banners over any app, Shorts blocker, content capture', st.accessibilityOn, () => bridge.open('accessibility'),
          'Android 13+ sideloaded: App info → ⋮ → Allow restricted settings, then enable it.'),
      ('Usage access', 'Time tracking per app', st.usageAccess, () => bridge.open('usage_access'), null),
      ('Health Connect', 'Steps, distance, exercise', hc, () async {
        final ok = await ref.read(activityServiceProvider).requestHealthPermissions();
        await ref.read(dbProvider).setSetting('health.granted', ok);
      }, null),
      ('Activity recognition', 'Step proof for the wake alarm', st.activityRecognition, () => runtime(Permission.activityRecognition), null),
      ('SMS', 'Escalation fallback when WhatsApp fails', st.smsPermission, () => runtime(Permission.sms), null),
      ('Battery: unrestricted', 'So Android never kills the alarm or guard', st.batteryUnrestricted, () => bridge.open('battery'), null),
    ];
    final done = rows.where((r) => r.$3).length;
    return ClayScreen(title: 'Setup', back: true, bottomPad: 40, children: [
      Text('$done of ${rows.length} ready', style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 14),
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClayContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.$1, style: Theme.of(context).textTheme.titleMedium), Text(r.$2, style: Theme.of(context).textTheme.bodySmall)])),
                ClayChip(r.$3 ? 'Ready' : 'Needs setup', color: r.$3 ? context.clay.mint : context.clay.butter, selected: false),
                if (!r.$3) Padding(padding: const EdgeInsets.only(left: 8), child: TextButton(onPressed: r.$4, child: const Text('Fix'))),
              ]),
              if (r.$5 != null && !r.$3) Padding(padding: const EdgeInsets.only(top: 6), child: Text(r.$5!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.clay.primary))),
            ]),
          ),
        ),
      if (st.needsAutostartTip)
        ClayContainer(child: Text('${st.brand}: also enable Autostart for Goal Compass and set battery to Unrestricted, or the OS may kill alarms and the guard.', style: Theme.of(context).textTheme.bodyMedium)),
      const SizedBox(height: 16),
      ClayButton('Open app settings', kind: ClayButtonKind.soft, onPressed: () => bridge.open('app_info')),
    ]);
  }
}
