import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../core/logic/pace.dart';
import '../../core/repos/goal_repo.dart';
import '../../core/repos/todo_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/money_format.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/clay_progress.dart';
import '../../core/widgets/screen.dart';
import '../todos/add_todo_sheet.dart';
import 'goal_sheet.dart';

class GoalDetailScreen extends ConsumerWidget {
  final String goalId;
  const GoalDetailScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final views = ref.watch(goalViewsProvider).value ?? [];
    final v = views.where((x) => x.goal.id == goalId).firstOrNull;
    final todos = (ref.watch(todosProvider).value ?? []).where((x) => x.goalId == goalId).toList();
    final aiReady = ref.watch(aiReadyProvider).value ?? false;
    if (v == null) return const ClayScreen(title: 'Goal', back: true, children: [EmptyState(text: 'Goal not found.')]);
    final g = v.goal;
    final repo = ref.read(goalRepoProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final money = g.type == 'money';

    return ClayScreen(title: g.title, back: true, bottomPad: 40, children: [
      ClayContainer(
        child: Column(children: [
          Row(children: [
            ClayProgressRing(value: v.pct / 100, color: statusColor(c, v.status), size: 110, center: Text('${v.pct.round()}%', style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 28))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              StatusChip(v.status),
              const SizedBox(height: 8),
              Text('${v.pct.round()}% · expected ${v.expected.round()}% · ${v.daysLeftN} days left', style: t.bodyMedium),
              if (g.why.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(g.why, style: t.bodySmall)),
            ])),
          ]),
          const SizedBox(height: 14),
          ClayProgressBar(value: v.pct / 100, color: statusColor(c, v.status), expected: v.expected / 100),
          if (money) ...[
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${formatPaise(v.savedPaise)} of ${formatPaise(g.targetPaise ?? 0)}', style: t.titleMedium),
            ]),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerLeft, child: Text('Need ${formatPaise(v.monthlyNeededPaise)}/month; this month ${formatPaise(v.thisMonthPaise)} so far', style: t.bodySmall)),
          ],
        ]),
      ),
      const SizedBox(height: 16),
      Wrap(spacing: 10, runSpacing: 10, children: [
        if (aiReady) ClayButton('Plan with AI', icon: Icons.auto_awesome_rounded, expand: false, onPressed: () => context.push('/plan/$goalId')),
        if (v.canReplan) ClayButton('Replan', icon: Icons.tune_rounded, kind: ClayButtonKind.soft, expand: false, onPressed: () => _replan(context, ref, v, aiReady)),
        ClayButton('Edit', icon: Icons.edit_rounded, kind: ClayButtonKind.soft, expand: false, onPressed: () => showGoalSheet(context, edit: g)),
        ClayButton(g.status == 'paused' ? 'Resume' : 'Pause', icon: g.status == 'paused' ? Icons.play_arrow_rounded : Icons.pause_rounded, kind: ClayButtonKind.soft, expand: false, onPressed: () => repo.setStatus(goalId, g.status == 'paused' ? 'active' : 'paused')),
        ClayButton(g.status == 'done' ? 'Reopen' : 'Complete', icon: Icons.check_rounded, kind: ClayButtonKind.soft, expand: false, onPressed: () => repo.setStatus(goalId, g.status == 'done' ? 'active' : 'done')),
      ]),
      if (aiReady)
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            Expanded(child: Text(g.digest == null ? 'No digest yet.' : (g.digestStale ? 'Digest is stale. Refreshes at most once a day.' : 'Digest up to date.'), style: t.bodySmall)),
            TextButton(
              onPressed: () async {
                try {
                  final n = await repo.refreshStaleDigests(ref.read(aiFeaturesProvider), force: true);
                  if (context.mounted) toast(context, n > 0 ? 'Digest refreshed' : 'Nothing to refresh');
                } catch (e) {
                  if (context.mounted) toast(context, e.toString());
                }
              },
              child: const Text('Refresh digest'),
            ),
          ]),
        ),
      SectionTitle('Stages', trailing: ClayIconButton(Icons.add_rounded, tooltip: 'Add stage', onPressed: () => _addStage(context, ref, g))),
      if (v.stages.isEmpty) EmptyState(text: 'No stages yet. Add your own${aiReady ? ' or plan with AI' : ''}.'),
      for (var i = 0; i < v.stages.length; i++) _StageTile(stage: v.stages[i], last: i == v.stages.length - 1, todos: todos.where((x) => x.stageId == v.stages[i].id).toList(), goal: g, now: now),
      Builder(builder: (_) {
        final loose = todos.where((x) => x.stageId == null && x.status == 'open').toList();
        if (loose.isEmpty) return const SizedBox();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Other todos'),
          for (final x in loose) _TodoLine(todo: x),
        ]);
      }),
      const SizedBox(height: 12),
      ClayButton('Add todo to this goal', icon: Icons.add_rounded, kind: ClayButtonKind.soft, onPressed: () => showAddTodoSheet(context, goalId: goalId)),
      const SizedBox(height: 12),
      ClayButton('Delete goal', kind: ClayButtonKind.danger, onPressed: () async {
        if (await confirm(context, 'Delete this goal?', 'Its stages go too. Todos stay, unlinked.', yes: 'Delete')) {
          await repo.delete(goalId);
          if (context.mounted) context.pop();
        }
      }),
    ]);
  }

  Future<void> _replan(BuildContext context, WidgetRef ref, GoalView v, bool aiReady) async {
    final repo = ref.read(goalRepoProvider);
    final n = await repo.localReplanGoal(v.goal);
    if (!context.mounted) return;
    toast(context, n == 0 ? 'No overdue stages to shift.' : 'Shifted $n stage(s) by their slip. Deadline kept.');
    if (aiReady && (v.status == GoalStatus.behind || v.status == GoalStatus.atRisk)) {
      if (await confirm(context, 'Ask AI too?', 'AI proposes the smallest set of changes. You review before anything changes.', yes: 'Ask AI') && context.mounted) {
        context.push('/plan/${v.goal.id}?replan=1');
      }
    }
  }

  Future<void> _addStage(BuildContext context, WidgetRef ref, Goal g) async {
    await ClaySheet.show(context, title: 'Add stage', child: _StageForm(goal: g));
  }
}

class _StageTile extends ConsumerWidget {
  final Stage stage;
  final bool last;
  final List<Todo> todos;
  final Goal goal;
  final int now;
  const _StageTile({required this.stage, required this.last, required this.todos, required this.goal, required this.now});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final done = stage.status == 'done';
    final overdue = !done && stage.dueAt < now;
    final dot = done ? c.mint : overdue ? c.rose : c.primary;
    final isToday = !done && startOfDayMs(stage.dueAt) == startOfDayMs(now);
    final repo = ref.read(goalRepoProvider);
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
          width: 28,
          child: Column(children: [
            Container(width: 18, height: 18, decoration: BoxDecoration(color: dot, shape: BoxShape.circle, boxShadow: [BoxShadow(color: c.shadowDark, offset: const Offset(2, 3), blurRadius: 6)]), child: done ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null),
            if (!last) Expanded(child: Container(width: 3, margin: const EdgeInsets.symmetric(vertical: 4), decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(2)))),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ClayContainer(
              padding: const EdgeInsets.all(14),
              onTap: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClayContainer(radius: ClayRadius.xl, child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ListTile(leading: const Icon(Icons.check_rounded), title: Text(done ? 'Mark open' : 'Mark done'), onTap: () { Navigator.pop(ctx); repo.setStageDone(stage, !done); }),
                    ListTile(leading: const Icon(Icons.edit_rounded), title: const Text('Edit'), onTap: () { Navigator.pop(ctx); ClaySheet.show(context, title: 'Edit stage', child: _StageForm(goal: goal, edit: stage)); }),
                    ListTile(leading: const Icon(Icons.add_rounded), title: const Text('Add todo here'), onTap: () { Navigator.pop(ctx); showAddTodoSheet(context, goalId: goal.id, stageId: stage.id); }),
                    ListTile(leading: Icon(Icons.delete_rounded, color: c.rose), title: const Text('Delete'), onTap: () { Navigator.pop(ctx); repo.deleteStage(stage); }),
                  ])),
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(stage.title, style: t.titleMedium?.copyWith(decoration: done ? TextDecoration.lineThrough : null))),
                  if (isToday) ClayChip('Today', color: c.butter, selected: true),
                ]),
                const SizedBox(height: 4),
                Text('${overdue ? 'Overdue · ' : ''}due ${shortDate(stage.dueAt)} · ${stage.weight}%', style: t.bodySmall?.copyWith(color: overdue ? c.rose : null)),
                if (stage.doneWhen.isNotEmpty) Text('Done when: ${stage.doneWhen}', style: t.bodySmall),
                for (final x in todos.where((x) => x.status != 'dropped')) Padding(padding: const EdgeInsets.only(top: 6), child: _TodoLine(todo: x, dense: true)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _TodoLine extends ConsumerWidget {
  final Todo todo;
  final bool dense;
  const _TodoLine({required this.todo, this.dense = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = todo.status == 'done';
    final repo = ref.read(todoRepoProvider);
    return GestureDetector(
      onTap: () => done ? repo.reopen(todo.id) : repo.complete(todo),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dense ? 2 : 6),
        child: Row(children: [
          Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 20, color: done ? context.clay.mint : context.clay.inkMuted),
          const SizedBox(width: 8),
          Expanded(child: Text(todo.title, style: TextStyle(decoration: done ? TextDecoration.lineThrough : null))),
          ScoreBadge(todo.score),
        ]),
      ),
    );
  }
}

class _StageForm extends ConsumerStatefulWidget {
  final Goal goal;
  final Stage? edit;
  const _StageForm({required this.goal, this.edit});
  @override
  ConsumerState<_StageForm> createState() => _StageFormState();
}

class _StageFormState extends ConsumerState<_StageForm> {
  final _title = TextEditingController(), _done = TextEditingController(), _weight = TextEditingController(text: '20');
  DateTime? _due;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.edit;
    if (e != null) {
      _title.text = e.title;
      _done.text = e.doneWhen;
      _weight.text = e.weight.toString();
      _due = fromMs(e.dueAt);
    }
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _due == null) return setState(() => _error = 'Title and due date are required.');
    setState(() { _busy = true; _error = null; });
    final due = toMs(DateTime.utc(_due!.year, _due!.month, _due!.day, 23, 59));
    final w = (int.tryParse(_weight.text) ?? 20).clamp(1, 100);
    final repo = ref.read(goalRepoProvider);
    if (widget.edit != null) {
      await repo.updateStage(widget.edit!.id, StagesCompanion(title: Value(_title.text.trim()), doneWhen: Value(_done.text.trim()), dueAt: Value(due), weight: Value(w)), widget.goal.id);
    } else {
      // alignment score on add: cache → rules → AI
      int? score;
      String note = '';
      try {
        final p = (await ref.read(todoRepoProvider).score([NewTodo(_title.text.trim(), estimateMin: 240)])).first;
        score = p.score;
        note = '${p.label}: ${p.score}. ${p.reason}';
      } catch (_) {}
      await repo.addStage(widget.goal.id, title: _title.text, dueMs: due, weight: w, doneWhen: _done.text.trim(), alignScore: score);
      if (mounted && note.isNotEmpty) toast(context, note);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ClayTextField(label: 'Stage', controller: _title, autofocus: true),
        const SizedBox(height: 12),
        ClayTextField(label: 'Done when', controller: _done),
        const SizedBox(height: 12),
        Row(children: [
          ClayChip(_due == null ? 'Due date' : 'Due ${shortDate(toMs(DateTime.utc(_due!.year, _due!.month, _due!.day)))}', icon: Icons.event_rounded, selected: _due != null, onTap: () async {
            final d = await pickDate(context, initial: _due, first: DateTime.now().subtract(const Duration(days: 30)));
            if (d != null) setState(() => _due = d);
          }),
          const SizedBox(width: 16),
          Expanded(child: ClayTextField(label: 'Weight %', controller: _weight, keyboardType: TextInputType.number)),
        ]),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: context.clay.rose, fontWeight: FontWeight.w700))),
        const SizedBox(height: 16),
        ClayButton('Save', busy: _busy, onPressed: _save),
      ]);
}
