import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/logic/recurrence.dart';
import '../../core/logic/todo_sort.dart';
import '../../core/providers.dart';
import '../../core/repos/todo_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

Future<void> showAddTodoSheet(BuildContext context, {Todo? edit, String? goalId, String? stageId}) =>
    ClaySheet.show(context, title: edit == null ? 'Add todo' : 'Edit todo', child: _AddTodo(edit: edit, goalId: goalId, stageId: stageId));

class _AddTodo extends ConsumerStatefulWidget {
  final Todo? edit;
  final String? goalId, stageId;
  const _AddTodo({this.edit, this.goalId, this.stageId});
  @override
  ConsumerState<_AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<_AddTodo> {
  final _title = TextEditingController();
  int _est = 30;
  int? _due, _remind;
  Recurrence _rec = Recurrence.none;
  String? _goalId, _stageId;
  ScorePreview? _preview;
  Timer? _debounce;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.edit;
    _goalId = widget.goalId;
    _stageId = widget.stageId;
    if (e != null) {
      _title.text = e.title;
      _est = e.estimateMin;
      _due = e.dueAt;
      _remind = e.remindAt;
      _rec = recurrenceFrom(e.recurrence);
      _goalId = e.goalId;
      _stageId = e.stageId;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _title.dispose();
    super.dispose();
  }

  List<String> get _lines => _title.text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

  void _onChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final lines = _lines;
      if (lines.length != 1) {
        setState(() => _preview = null);
        return;
      }
      // live preview: cache + local rules only (no AI, no tokens)
      final p = (await ref.read(todoRepoProvider).score([NewTodo(lines.first, estimateMin: _est)], useAi: false)).first;
      if (mounted) setState(() => _preview = p);
    });
  }

  Future<void> _pickDateTime(bool remind) async {
    final d = await pickDate(context);
    if (d == null || !mounted) return;
    int ms = toMs(DateTime.utc(d.year, d.month, d.day));
    if (remind) {
      final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
      if (t == null) return;
      ms += (t.hour * 60 + t.minute) * 60000;
    }
    setState(() => remind ? _remind = ms : _due = ms);
  }

  Future<void> _save() async {
    final lines = _lines;
    if (lines.isEmpty) {
      setState(() => _error = 'Type a title first.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final repo = ref.read(todoRepoProvider);
    try {
      if (widget.edit != null) {
        final e = widget.edit!;
        final changed = lines.first != e.title;
        ScorePreview? p;
        if (changed) p = (await repo.score([NewTodo(lines.first, estimateMin: _est)])).first;
        await repo.update(
          e.id,
          TodosCompanion(
            title: Value(lines.first),
            estimateMin: Value(_est),
            dueAt: Value(_due),
            remindAt: Value(_remind),
            recurrence: Value(_rec.name),
            goalId: Value(_goalId),
            stageId: Value(_stageId),
            score: p == null ? const Value.absent() : Value(p.score),
            reason: p == null ? const Value.absent() : Value(p.reason),
            scoreSource: p == null ? const Value.absent() : Value(p.source),
          ),
        );
      } else {
        final items = [
          for (final l in lines)
            NewTodo(l, estimateMin: _est, dueMs: _due, remindMs: _remind, goalId: _goalId, stageId: _stageId, recurrence: _rec)
        ];
        // ONE AI call for the whole list when local rules are unsure.
        final scores = await repo.score(items);
        await repo.addMany(items, scores: scores);
        if (mounted && scores.length == 1) {
          final s = scores.first;
          toast(context, '${s.label}: ${s.score}. ${s.reason}');
        } else if (mounted) {
          toast(context, 'Added ${items.length} todos');
        }
      }
      if (mounted) Navigator.pop(context);
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
    final goals = ref.watch(goalViewsProvider).value ?? [];
    final multi = _lines.length > 1;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ClayTextField(
        controller: _title,
        hint: widget.edit == null ? 'What needs doing? (paste a list, one per line)' : 'Title',
        maxLines: 4,
        autofocus: true,
        onChanged: (v) {
          setState(() {});
          _onChanged(v);
        },
      ),
      const SizedBox(height: 10),
      if (_preview != null && !multi)
        Row(children: [
          ScoreBadge(_preview!.score),
          const SizedBox(width: 10),
          Expanded(child: Text('${_preview!.label} · ${_preview!.reason}', style: Theme.of(context).textTheme.bodySmall)),
        ])
      else if (multi)
        Text('${_lines.length} todos. One AI call scores them all if needed.', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 12),
      Text('Estimate', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 6),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final o in estimateOptions) ClayChip(o.$2, selected: _est == o.$1, onTap: () => setState(() => _est = o.$1)),
      ]),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [
        ClayChip(_due == null ? 'Due date' : 'Due ${shortDate(_due!)}', icon: Icons.event_rounded, color: c.sky, selected: _due != null, onTap: () => _pickDateTime(false)),
        ClayChip(_remind == null ? 'Remind me' : 'Remind ${shortDate(_remind!)} ${timeLabel(_remind!)}', icon: Icons.alarm_rounded, color: c.peach, selected: _remind != null, onTap: () => _pickDateTime(true)),
        for (final r in Recurrence.values)
          ClayChip(r == Recurrence.none ? 'No repeat' : r.name, color: c.mint, selected: _rec == r, onTap: () => setState(() => _rec = r)),
      ]),
      if (goals.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text('Goal', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ClayChip('Auto', selected: _goalId == null, onTap: () => setState(() { _goalId = null; _stageId = null; })),
          for (final g in goals.where((g) => g.goal.status == 'active'))
            ClayChip(g.goal.title, color: Color(g.goal.color), selected: _goalId == g.goal.id, onTap: () => setState(() { _goalId = g.goal.id; _stageId = null; })),
        ]),
        if (_goalId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in goals.where((g) => g.goal.id == _goalId).expand((g) => g.stages).where((s) => s.status == 'open'))
                ClayChip(s.title, selected: _stageId == s.id, onTap: () => setState(() => _stageId = _stageId == s.id ? null : s.id)),
            ]),
          ),
      ],
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: TextStyle(color: c.rose, fontWeight: FontWeight.w700))),
      const SizedBox(height: 16),
      ClayButton(_saving ? 'Scoring…' : (widget.edit == null ? (multi ? 'Add ${_lines.length} todos' : 'Add todo') : 'Save'), busy: _saving, onPressed: _save),
    ]);
  }
}
