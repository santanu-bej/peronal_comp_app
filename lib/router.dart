import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/backup/backup_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/dashboard/shell.dart';
import 'features/focus/focus_screen.dart';
import 'features/goals/ai_review_screen.dart';
import 'features/goals/goal_detail_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/money/money_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/setup_screen.dart';
import 'features/routines/morning_screen.dart';
import 'features/routines/routines_screen.dart';
import 'features/routines/wake_screen.dart';
import 'features/settings/gallery_screen.dart';
import 'features/settings/log_screen.dart';
import 'features/settings/more_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/whatsapp_screen.dart';
import 'features/time/time_screen.dart';
import 'features/todos/quick_add_route.dart';
import 'features/todos/todos_screen.dart';

GoRouter buildRouter(String initial) => GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => AppShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const DashboardScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/goals', builder: (_, _) => const GoalsScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/todos', builder: (_, _) => const TodosScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/time', builder: (_, _) => const TimeScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/more', builder: (_, _) => const MoreScreen())]),
          ],
        ),
        GoRoute(path: '/goal/:id', builder: (_, s) => GoalDetailScreen(goalId: s.pathParameters['id']!)),
        GoRoute(path: '/plan/:id', builder: (_, s) => AiReviewScreen(goalId: s.pathParameters['id']!, replan: s.uri.queryParameters['replan'] == '1')),
        GoRoute(path: '/todo/:id', redirect: (_, _) => '/todos'),
        GoRoute(path: '/add', builder: (_, _) => const QuickAddRoute()),
        GoRoute(path: '/money', builder: (_, _) => const MoneyScreen()),
        GoRoute(path: '/routines', builder: (_, _) => const RoutinesScreen()),
        GoRoute(path: '/focus', builder: (_, _) => const FocusScreen()),
        GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
        GoRoute(path: '/settings/whatsapp', builder: (_, _) => const WhatsappScreen()),
        GoRoute(path: '/backup', builder: (_, _) => const BackupScreen()),
        GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
        GoRoute(path: '/log', builder: (_, _) => const LogScreen()),
        GoRoute(path: '/gallery', builder: (_, _) => const GalleryScreen()),
        GoRoute(path: '/wake', builder: (_, s) => WakeScreen(routineId: s.uri.queryParameters['id'] ?? '')),
        GoRoute(path: '/morning', builder: (_, _) => const MorningScreen()),
      ],
      errorBuilder: (_, _) => const Scaffold(body: Center(child: Text('Page not found'))),
    );
