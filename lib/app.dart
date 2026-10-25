import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/native/native_bridge.dart';
import 'core/providers.dart';
import 'core/theme/clay_theme.dart';
import 'core/theme/clay_tokens.dart';
import 'router.dart';

class GoalCompassApp extends ConsumerStatefulWidget {
  final bool startOnboarding;
  const GoalCompassApp({super.key, required this.startOnboarding});
  @override
  ConsumerState<GoalCompassApp> createState() => _AppState();
}

class _AppState extends ConsumerState<GoalCompassApp> with WidgetsBindingObserver {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = buildRouter(widget.startOnboarding ? '/onboarding' : '/home');
    WidgetsBinding.instance.addObserver(this);
    NativeBridge.routes.listen((r) => _router.go(r));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(nativeSyncProvider).start();
      await _resume();
    });
  }

  Future<void> _resume() async {
    try {
      await ref.read(timeServiceProvider).aggregate();
      await ref.read(activityServiceProvider).refreshToday();
      await ref.read(todoRepoProvider).rollRecurring();
      await ref.read(moneyRepoProvider).applyRecurring();
      ref.invalidate(nativeStatusProvider);
    } catch (e) {
      await ref.read(dbProvider).log('sync', 'Resume sync failed: $e', level: 'error');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) _resume();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = switch (ref.watch(themeModeSettingProvider)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return MaterialApp.router(
      title: 'Goal Compass',
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: buildClayTheme(ClayColors.light),
      darkTheme: buildClayTheme(ClayColors.dark_),
      routerConfig: _router,
    );
  }
}
