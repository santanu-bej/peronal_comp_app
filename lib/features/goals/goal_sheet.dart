import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/ai/ai_client.dart';
import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../core/repos/goal_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/money_format.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

Future<void> showGoalSheet(BuildContext context, {Goal? edit}) =>
    ClaySheet.show(context, title: edit == null ? 'New goal' : 'Edit goal', child: GoalForm(edit: edit));

/// Create/edit form. Saving never needs AI; "Save & plan with AI" opens the review screen.
class GoalForm extends ConsumerStatefulWidget {
  final Goal? edit;
  final void Function(String goalId, bool plan)? onSaved;
  final bool compact;
  const GoalForm({super.key, this.edit, this.onSaved, this.compact = false});
  @override
  ConsumerState<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends ConsumerState<GoalForm> {
  final _title = TextEditingController(), _why = TextEditingController(), _target = TextEditingController();
  DateTime? _deadline;
  String _type = 'general';
  int _priority = 3;
  int _color = goalColors.first;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final g = widget.edit;
    if (g != null) {
      _title.text = g.title;
      _why.text = g.why;
      _type = g.type;
      _priority = g.priority;
      _color = g.color;
      _deadline = fromMs(g.deadlineAt);
      if (g.targetPaise != null) _target.text = (g.targetPaise! ~/ 100).toString();
    }
  }

  Future<void> _save(bool plan) async {
    final title = _title.text.trim();
    if (title.isEmpty) return setState(() => _error = 'Give the goal a title.');
    if (_deadline == null) return setState(() => _error = 'Pick a deadline.');
    int? target;
    if (_type == 'money') {
      target = parseRupeesToPaise(_target.text);
      if (target == null || target <= 0) return setState(() => _error = 'Enter the target amount in ₹.');
    }
    final repo = ref.read(goalRepoProvider);
    if (widget.edit == null && await repo.activeCount() >= activeGoalLimit) {
      return setState(() => _error = 'You already have $activeGoalLimit active goals. Pause or finish one first.');
    }
    setState(() { _busy = true; _error = null; });
    final deadlineMs = toMs(DateTime.utc(_deadline!.year, _deadline!.month, _deadline!.day, 23, 59));
    String id;
    if (widget.edit == null) {
      id = await repo.create(title: title, why: _why.text, deadlineMs: deadlineMs, type: _type, targetPaise: target, priority: _priority, color: _color);
    } else {
      id = widget.edit!.id;
      await repo.update(id, GoalsCompanion(title: Value(title), why: Value(_why.text.trim()), deadlineAt: Value(deadlineMs), type: Value(_type), targetPaise: Value(target), priority: Value(_priority), color: Value(_color)));
    }
    if (!mounted) return;
    if (widget.onSaved != null) {
      widget.onSaved!(id, plan);
    } else {
      Navigator.pop(context);
      if (plan) context.push('/plan/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final aiReady = ref.watch(aiReadyProvider).value ?? false;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ClayTextField(label: 'Goal', hint: 'Earn ₹10 lakh profit', controller: _title, maxLength: 80),
      const SizedBox(height: 12),
      ClayTextField(label: 'Why it matters', hint: 'One line', controller: _why, maxLength: 140),
      const SizedBox(height: 12),
      Text('Deadline', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerLeft,
        child: ClayChip(_deadline == null ? 'Pick date' : longDate(toMs(DateTime.utc(_deadline!.year, _deadline!.month, _deadline!.day))), icon: Icons.event_rounded, selected: _deadline != null, onTap: () async {
          final d = await pickDate(context, initial: _deadline ?? DateTime.now().add(const Duration(days: 90)), first: DateTime.now());
          if (d != null) setState(() => _deadline = d);
        }),
      ),
      const SizedBox(height: 12),
      Wrap(spacing: 8, children: [
        ClayChip('General', selected: _type == 'general', onTap: () => setState(() => _type = 'general')),
        ClayChip('Money', color: c.peach, selected: _type == 'money', onTap: () => setState(() => _type = 'money')),
      ]),
      if (_type == 'money') ...[
        const SizedBox(height: 12),
        ClayTextField(label: 'Target amount (₹)', controller: _target, keyboardType: TextInputType.number),
      ],
      const SizedBox(height: 12),
      Text('Priority', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 6),
      Wrap(spacing: 8, children: [for (var p = 1; p <= 5; p++) ClayChip('$p', selected: _priority == p, onTap: () => setState(() => _priority = p))]),
      const SizedBox(height: 12),
      Wrap(spacing: 10, children: [
        for (final col in goalColors)
          GestureDetector(
            onTap: () => setState(() => _color = col),
            child: Semantics(label: 'Colour', selected: _color == col, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: Color(col), shape: BoxShape.circle, border: Border.all(color: _color == col ? c.ink : Colors.transparent, width: 3)))),
          ),
      ]),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: TextStyle(color: c.rose, fontWeight: FontWeight.w700))),
      const SizedBox(height: 16),
      if (aiReady && widget.edit == null) ...[
        ClayButton('Save & plan with AI', icon: Icons.auto_awesome_rounded, busy: _busy, onPressed: () => _save(true)),
        const SizedBox(height: 10),
        ClayButton('Save without AI', kind: ClayButtonKind.soft, onPressed: _busy ? null : () => _save(false)),
      ] else
        ClayButton('Save', busy: _busy, onPressed: () => _save(false)),
    ]);
  }
}

// Silence unused import warnings for classes referenced only in docs.
// ignore: unused_element
const _x = AiException;
