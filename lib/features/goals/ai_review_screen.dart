import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/ai/ai_client.dart';
import '../../core/ai/ai_features.dart';
import '../../core/db/database.dart';
import '../../core/logic/todo_sort.dart';
import '../../core/providers.dart';
import '../../core/repos/todo_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

/// Review screen for A1 (plan) and A4 (replan). Nothing is saved until "Add selected".
class AiReviewScreen extends ConsumerStatefulWidget {
  final String goalId;
  final bool replan;
  const AiReviewScreen({super.key, required this.goalId, required this.replan});
  @override
  ConsumerState<AiReviewScreen> createState() => _S();
}

class _S extends ConsumerState<AiReviewScreen> {
  Goal? _goal;
  PlanResult? _plan;
  ReplanResult? _re;
  List<Stage> _stages = [];
  final _applyChange = <int, bool>{};
  final _applyAdd = <int, bool>{};
  final _applyTodo = <int, bool>{};
  bool _moveDeadline = false;
  bool _loading = true, _saving = false;
  String? _error;
  bool _needsConfirm = false;
  int _tokens = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run({bool confirmed = false}) async {
    setState(() {
      _loading = true;
      _error = null;
      _needsConfirm = false;
    });
    try {
      final db = ref.read(dbProvider);
      final goal = await (db.select(db.goals)..where((g) => g.id.equals(widget.goalId))).getSingle();
      _goal = goal;
      final ai = ref.read(aiFeaturesProvider);
      final now = DateTime.now().millisecondsSinceEpoch;
      if (!widget.replan) {
        final others = [for (final g in await ref.read(goalRepoProvider).activeGoalsOrdered()) if (g.id != goal.id) g.title];
        final p = await ai.plan(
          title: goal.title,
          why: goal.why,
          deadlineMs: goal.deadlineAt,
          type: goal.type,
          targetPaise: goal.targetPaise,
          aboutMe: ref.read(aboutMeProvider),
          otherGoals: others,
          confirmed: confirmed,
        );
        _plan = p;
        _tokens = p.tokens;
      } else {
        final v = await ref.read(goalRepoProvider).viewFor(goal, now);
        _stages = v.stages;
        final payload = {
          'digest': goal.digest ?? '${goal.title}. ${goal.why}',
          'today': dateKey(now),
          'deadline': dateKey(goal.deadlineAt),
          'pct': v.pct.round(),
          'exp': v.expected.round(),
          'stages': [
            for (var i = 0; i < v.stages.length; i++)
              {
                'i': i,
                't': v.stages[i].title,
                'due': dateKey(v.stages[i].dueAt),
                's': v.stages[i].status,
                'slip': v.stages[i].status == 'open' && v.stages[i].dueAt < now ? daysBetween(v.stages[i].dueAt, now) : 0,
              }
          ],
        };
        final r = await ai.replan(payload, todayMs: startOfDayMs(now), deadlineMs: goal.deadlineAt);
        _re = r;
        for (var i = 0; i < r.changes.length; i++) { _applyChange[i] = true; }
        for (var i = 0; i < r.add.length; i++) { _applyAdd[i] = true; }
        for (var i = 0; i < r.newTodos.length; i++) { _applyTodo[i] = true; }
        _moveDeadline = r.moveDeadlineMs != null;
      }
      setState(() => _loading = false);
    } on AiException catch (e) {
      setState(() {
        _loading = false;
        _error = e.message;
        _needsConfirm = e.needsConfirm;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Something went wrong: $e';
      });
    }
  }

  int get _count {
    if (_plan != null) return _plan!.stages.where((s) => s.selected).length + _plan!.todos.where((t) => t.selected).length;
    if (_re != null) return _applyChange.values.where((x) => x).length + _applyAdd.values.where((x) => x).length + _applyTodo.values.where((x) => x).length + (_moveDeadline ? 1 : 0);
    return 0;
  }

  Future<void> _apply() async {
    setState(() => _saving = true);
    final repo = ref.read(goalRepoProvider);
    final todos = ref.read(todoRepoProvider);
    final goal = _goal!;
    try {
      if (_plan != null) {
        final pending = await repo.applyPlan(goal.id, _plan!);
        final items = [for (final p in pending) NewTodo(p.todo.title, estimateMin: p.todo.estimateMin, goalId: goal.id, stageId: p.stageId)];
        if (items.isNotEmpty) await todos.addMany(items, useAi: false);
      } else if (_re != null) {
        final r = _re!;
        for (var i = 0; i < r.changes.length; i++) {
          if (_applyChange[i] != true) continue;
          final ch = r.changes[i];
          if (ch.stage < 0 || ch.stage >= _stages.length) continue;
          final s = _stages[ch.stage];
          if (ch.drop) {
            await repo.updateStage(s.id, const StagesCompanion(status: Value('dropped')), goal.id);
          } else {
            await repo.updateStage(s.id, StagesCompanion(title: ch.title == null ? const Value.absent() : Value(ch.title!), dueAt: ch.dueMs == null ? const Value.absent() : Value(ch.dueMs!)), goal.id);
          }
        }
        final newIds = <String>[];
        for (var i = 0; i < r.add.length; i++) {
          if (_applyAdd[i] != true) continue;
          newIds.add(await repo.addStage(goal.id, title: r.add[i].title, dueMs: r.add[i].dueMs, weight: r.add[i].weight, source: 'ai'));
        }
        final items = <NewTodo>[];
        for (var i = 0; i < r.newTodos.length; i++) {
          if (_applyTodo[i] != true) continue;
          final t = r.newTodos[i];
          items.add(NewTodo(t.title, estimateMin: t.estimateMin, goalId: goal.id, stageId: t.stage >= 0 && t.stage < _stages.length ? _stages[t.stage].id : null));
        }
        if (items.isNotEmpty) await todos.addMany(items, useAi: false);
        if (_moveDeadline && r.moveDeadlineMs != null) {
          await repo.update(goal.id, GoalsCompanion(deadlineAt: Value(r.moveDeadlineMs!)));
        }
      }
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final title = widget.replan ? 'Replan' : 'AI plan';
    if (_loading) {
      return ClayScreen(title: title, back: true, children: [
        const SizedBox(height: 80),
        Center(child: CircularProgressIndicator(color: c.primary)),
        const SizedBox(height: 16),
        Center(child: Text(widget.replan ? 'Asking Claude for the smallest fix…' : 'Claude is planning your goal…', style: t.bodyMedium)),
      ]);
    }
    if (_error != null && _plan == null && _re == null) {
      return ClayScreen(title: title, back: true, children: [
        const SizedBox(height: 40),
        Text(_error!, style: t.bodyLarge?.copyWith(color: c.rose, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Nothing you typed was lost.', style: t.bodySmall),
        const SizedBox(height: 20),
        ClayButton(_needsConfirm ? 'Spend tokens anyway' : 'Retry', icon: Icons.refresh_rounded, onPressed: () => _run(confirmed: _needsConfirm)),
        const SizedBox(height: 10),
        ClayButton('Settings', kind: ClayButtonKind.soft, onPressed: () => context.push('/settings')),
      ]);
    }

    final children = <Widget>[];
    if (_plan != null) {
      children.add(const SectionTitle('Stages'));
      for (final s in _plan!.stages) {
        children.add(_ReviewCard(
          selected: s.selected,
          onToggle: (v) => setState(() => s.selected = v),
          title: s.title,
          sub: '${shortDate(s.dueMs)} · ${s.weight}%${s.doneWhen.isEmpty ? '' : '\nDone when: ${s.doneWhen}'}',
          onEdit: () async {
            final r = await _editDialog(s.title, s.dueMs);
            if (r != null) setState(() { s.title = r.$1; s.dueMs = r.$2 ?? s.dueMs; });
          },
        ));
      }
      children.add(const SectionTitle('Setup todos'));
      for (final td in _plan!.todos) {
        children.add(_ReviewCard(
          selected: td.selected,
          onToggle: (v) => setState(() => td.selected = v),
          title: td.title,
          sub: '${estimateLabel(td.estimateMin)} · stage: ${_plan!.stages[td.stageIndex].title}',
          onEdit: () async {
            final r = await _editDialog(td.title, null);
            if (r != null) setState(() => td.title = r.$1);
          },
        ));
      }
    } else if (_re != null) {
      final r = _re!;
      children.add(ClayContainer(child: Text(r.summary.isEmpty ? 'Proposed changes' : r.summary, style: t.bodyLarge)));
      if (r.moveDeadlineMs != null) {
        children.add(Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _ReviewCard(selected: _moveDeadline, onToggle: (v) => setState(() => _moveDeadline = v), title: 'Move deadline to ${longDate(r.moveDeadlineMs!)}', sub: 'AI says the current deadline is not reachable.'),
        ));
      }
      children.add(const SectionTitle('Stage changes'));
      for (var i = 0; i < r.changes.length; i++) {
        final ch = r.changes[i];
        if (ch.stage < 0 || ch.stage >= _stages.length) continue;
        final s = _stages[ch.stage];
        children.add(_ReviewCard(
          selected: _applyChange[i] == true,
          onToggle: (v) => setState(() => _applyChange[i] = v),
          title: ch.drop ? 'Drop: ${s.title}' : (ch.title ?? s.title),
          sub: ch.drop ? 'Remove this stage' : '${shortDate(s.dueAt)} → ${shortDate(ch.dueMs ?? s.dueAt)}',
        ));
      }
      if (r.add.isNotEmpty) children.add(const SectionTitle('New stages'));
      for (var i = 0; i < r.add.length; i++) {
        children.add(_ReviewCard(selected: _applyAdd[i] == true, onToggle: (v) => setState(() => _applyAdd[i] = v), title: r.add[i].title, sub: '${shortDate(r.add[i].dueMs)} · ${r.add[i].weight}%'));
      }
      if (r.newTodos.isNotEmpty) children.add(const SectionTitle('New todos'));
      for (var i = 0; i < r.newTodos.length; i++) {
        children.add(_ReviewCard(selected: _applyTodo[i] == true, onToggle: (v) => setState(() => _applyTodo[i] = v), title: r.newTodos[i].title, sub: estimateLabel(r.newTodos[i].estimateMin)));
      }
    }
    return ClayScreen(
      title: title,
      back: true,
      bottomPad: 140,
      bottom: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(_error!, style: TextStyle(color: c.rose, fontWeight: FontWeight.w700))),
            if (_tokens > 0) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text('$_tokens tokens used', style: t.bodySmall)),
            ClayButton('Add selected ($_count)', busy: _saving, onPressed: _count == 0 ? null : _apply),
          ]),
        ),
      ),
      children: children,
    );
  }

  Future<(String, int?)?> _editDialog(String title, int? due) async {
    final ctrl = TextEditingController(text: title);
    int? d = due;
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Edit'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: ctrl, maxLength: 80),
            if (d != null)
              TextButton(
                onPressed: () async {
                  final p = await pickDate(ctx, initial: fromMs(d!), first: DateTime.now());
                  if (p != null) set(() => d = toMs(DateTime.utc(p.year, p.month, p.day)));
                },
                child: Text('Due ${shortDate(d!)}'),
              ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('OK')),
          ],
        ),
      ),
    );
    if (r != true || ctrl.text.trim().isEmpty) return null;
    return (ctrl.text.trim(), d);
  }
}

class _ReviewCard extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool> onToggle;
  final String title, sub;
  final VoidCallback? onEdit;
  const _ReviewCard({required this.selected, required this.onToggle, required this.title, required this.sub, this.onEdit});
  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: selected ? 1 : 0.55,
        child: ClayContainer(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Semantics(
              checked: selected,
              child: GestureDetector(
                onTap: () => onToggle(!selected),
                child: AnimatedContainer(
                  duration: ClayMotion.base,
                  curve: ClayMotion.pop,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: selected ? c.primary : c.surfaceAlt, borderRadius: BorderRadius.circular(9)),
                  child: selected ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: t.titleMedium), const SizedBox(height: 2), Text(sub, style: t.bodySmall)])),
            if (onEdit != null) IconButton(onPressed: onEdit, tooltip: 'Edit', icon: Icon(Icons.edit_rounded, size: 20, color: c.inkMuted)),
          ]),
        ),
      ),
    );
  }
}
