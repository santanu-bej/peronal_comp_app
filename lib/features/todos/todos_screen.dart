import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/logic/todo_sort.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';
import 'add_todo_sheet.dart';

enum _Tab { today, upcoming, all, done }

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});
  @override
  ConsumerState<TodosScreen> createState() => _S();
}

class _S extends ConsumerState<TodosScreen> {
  _Tab _tab = _Tab.today;

  List<Todo> _filter(List<Todo> all, int now) {
    final today = startOfDayMs(now);
    final tomorrowEnd = today + 2 * msPerDay;
    final open = all.where((t) => t.status == 'open').toList();
    switch (_tab) {
      case _Tab.done:
        return all.where((t) => t.status == 'done').toList()..sort((a, b) => (b.doneAt ?? 0).compareTo(a.doneAt ?? 0));
      case _Tab.upcoming:
        return open.where((t) => t.dueAt != null && t.dueAt! >= today + msPerDay).toList()..sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
      case _Tab.all:
        return _sorted(open, now);
      case _Tab.today:
        // due today/overdue, or no due date but high score
        return _sorted(open.where((t) => (t.dueAt != null && t.dueAt! < tomorrowEnd - msPerDay) || (t.dueAt == null && (t.score ?? 0) >= 50)).toList(), now);
    }
  }

  List<Todo> _sorted(List<Todo> l, int now) {
    final s = sortTodos([for (final t in l) SortableTodo(t.id, t.title, t.score, t.dueAt, t.estimateMin)], now, startOfDayMs(now));
    final byId = {for (final t in l) t.id: t};
    return [for (final x in s) byId[x.id]!];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final todos = ref.watch(todosProvider).value ?? [];
    final goals = {for (final g in ref.watch(goalViewsProvider).value ?? <dynamic>[]) g.goal.id as String: g.goal as Goal};
    final list = _filter(todos, now);
    return ClayScreen(
      title: 'Todo',
      children: [
        Wrap(spacing: 8, children: [
          for (final t in _Tab.values) ClayChip(t.name[0].toUpperCase() + t.name.substring(1), selected: _tab == t, onTap: () => setState(() => _tab = t)),
        ]),
        const SizedBox(height: 16),
        if (list.isEmpty)
          EmptyState(text: _tab == _Tab.done ? 'Nothing finished yet.' : 'No todos here. Add one and it gets scored against your goals.', buttonLabel: _tab == _Tab.done ? null : 'Add todo', onPressed: () => showAddTodoSheet(context)),
        for (final t in list) _Row(todo: t, goal: goals[t.goalId], now: now),
      ],
    );
  }
}

class _Row extends ConsumerWidget {
  final Todo todo;
  final Goal? goal;
  final int now;
  const _Row({required this.todo, required this.goal, required this.now});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final repo = ref.read(todoRepoProvider);
    final done = todo.status == 'done';
    final overdue = !done && todo.dueAt != null && todo.dueAt! < startOfDayMs(now);
    final meta = <String>[
      estimateLabel(todo.estimateMin),
      if (todo.dueAt != null) 'due ${shortDate(todo.dueAt!)}',
      if (todo.remindAt != null) '⏰ ${timeLabel(todo.remindAt!)}',
      if (todo.recurrence != 'none') '↻ ${todo.recurrence}',
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(todo.id),
        background: _bg(c.mint, Icons.check_rounded, Alignment.centerLeft),
        secondaryBackground: _bg(c.butter, Icons.snooze_rounded, Alignment.centerRight),
        confirmDismiss: (dir) async {
          if (dir == DismissDirection.startToEnd) {
            if (done) {
              await repo.reopen(todo.id);
            } else {
              await repo.complete(todo);
            }
          } else {
            await showAddTodoSheet(context, edit: todo);
          }
          return false;
        },
        child: ClayContainer(
          padding: const EdgeInsets.all(14),
          onTap: () => showAddTodoSheet(context, edit: todo),
          child: Row(children: [
            Semantics(
              label: done ? 'Mark not done' : 'Mark done',
              button: true,
              child: GestureDetector(
                onTap: () => done ? repo.reopen(todo.id) : repo.complete(todo),
                child: AnimatedContainer(
                  duration: ClayMotion.base,
                  curve: ClayMotion.pop,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: done ? c.mint : c.surfaceAlt, shape: BoxShape.circle),
                  child: done ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(todo.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(decoration: done ? TextDecoration.lineThrough : null, color: overdue ? c.rose : null)),
                const SizedBox(height: 4),
                Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  if (goal != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Color(goal!.color).withValues(alpha: 0.35), borderRadius: BorderRadius.circular(10)), child: Text(goal!.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                  Text(meta.join(' · '), style: Theme.of(context).textTheme.bodySmall),
                ]),
              ]),
            ),
            const SizedBox(width: 8),
            ScoreBadge(todo.score),
          ]),
        ),
      ),
    );
  }

  Widget _bg(Color color, IconData icon, Alignment a) =>
      Container(alignment: a, padding: const EdgeInsets.symmetric(horizontal: 24), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(ClayRadius.lg)), child: Icon(icon, color: Colors.white));
}
