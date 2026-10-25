import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/widgets/clay_container.dart';
import '../goals/goal_sheet.dart';
import '../money/money_sheet.dart';
import '../todos/add_todo_sheet.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.flag_rounded, 'Goals'),
    (Icons.check_circle_rounded, 'Todo'),
    (Icons.timelapse_rounded, 'Time'),
    (Icons.grid_view_rounded, 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final i = shell.currentIndex;
    final showFab = i <= 2;
    return Scaffold(
      extendBody: true,
      body: shell,
      floatingActionButton: showFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 78),
              child: GestureDetector(
                onLongPress: () => _longPress(context),
                child: ClayContainer(
                  width: 60,
                  height: 60,
                  radius: 30,
                  depth: ClayDepth.floating,
                  color: c.primary,
                  padding: EdgeInsets.zero,
                  onTap: () => showAddTodoSheet(context),
                  child: Semantics(label: 'Quick add', child: const Icon(Icons.add_rounded, color: Colors.white, size: 30)),
                ),
              ),
            )
          : null,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: ClayContainer(
            depth: ClayDepth.floating,
            radius: ClayRadius.pill,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              for (var k = 0; k < _items.length; k++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: k == i,
                    label: _items[k].$2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => shell.goBranch(k, initialLocation: k == i),
                      child: AnimatedContainer(
                        duration: context.reduceMotion ? Duration.zero : ClayMotion.base,
                        curve: ClayMotion.smooth,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(color: k == i ? c.primary : Colors.transparent, borderRadius: BorderRadius.circular(ClayRadius.pill)),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(_items[k].$1, size: 22, color: k == i ? Colors.white : c.inkMuted),
                          Text(_items[k].$2, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: k == i ? Colors.white : c.inkMuted)),
                        ]),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  void _longPress(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: ClayContainer(
          radius: ClayRadius.xl,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(leading: const Icon(Icons.check_circle_rounded), title: const Text('Todo'), onTap: () { Navigator.pop(ctx); showAddTodoSheet(context); }),
            ListTile(leading: const Icon(Icons.flag_rounded), title: const Text('Goal'), onTap: () { Navigator.pop(ctx); showGoalSheet(context); }),
            ListTile(leading: const Icon(Icons.currency_rupee_rounded), title: const Text('Money entry'), onTap: () { Navigator.pop(ctx); showMoneySheet(context); }),
          ]),
        ),
      ),
    );
  }
}
