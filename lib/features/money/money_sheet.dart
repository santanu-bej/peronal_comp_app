import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/money_format.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

const moneyCategories = ['general', 'salary', 'rent', 'staff', 'food', 'travel', 'tools', 'tax', 'investment'];

Future<void> showMoneySheet(BuildContext context, {bool recurring = false}) =>
    ClaySheet.show(context, title: recurring ? 'Recurring entry' : 'Add money entry', child: _MoneyForm(recurring: recurring));

class _MoneyForm extends ConsumerStatefulWidget {
  final bool recurring;
  const _MoneyForm({required this.recurring});
  @override
  ConsumerState<_MoneyForm> createState() => _S();
}

class _S extends ConsumerState<_MoneyForm> {
  final _amount = TextEditingController(), _note = TextEditingController(), _day = TextEditingController(text: '1');
  String _kind = 'expense', _cat = 'general';
  String? _goalId, _error;
  DateTime _date = DateTime.now();

  Future<void> _save() async {
    final p = parseRupeesToPaise(_amount.text);
    if (p == null || p <= 0) return setState(() => _error = 'Enter an amount like 1500 or 1,500.50');
    final repo = ref.read(moneyRepoProvider);
    if (widget.recurring) {
      if (_note.text.trim().isEmpty) return setState(() => _error = 'Give it a title (salary, rent…).');
      await repo.addRecurring(title: _note.text.trim(), amountPaise: p, kind: _kind, category: _cat, day: (int.tryParse(_day.text) ?? 1).clamp(1, 28), goalId: _goalId);
      await repo.applyRecurring();
    } else {
      await repo.add(amountPaise: p, kind: _kind, category: _cat, note: _note.text.trim().isEmpty ? null : _note.text.trim(), dateMs: toMs(DateTime.utc(_date.year, _date.month, _date.day)), goalId: _goalId);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final goals = (ref.watch(goalViewsProvider).value ?? []).where((g) => g.goal.type == 'money' && g.goal.status == 'active').toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 8, children: [
        ClayChip('Expense', color: c.rose, selected: _kind == 'expense', onTap: () => setState(() => _kind = 'expense')),
        ClayChip('Income', color: c.mint, selected: _kind == 'income', onTap: () => setState(() => _kind = 'income')),
        ClayChip('Saving', color: c.peach, selected: _kind == 'saving', onTap: () => setState(() => _kind = 'saving')),
      ]),
      const SizedBox(height: 12),
      ClayTextField(label: 'Amount (₹)', controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), autofocus: true),
      const SizedBox(height: 12),
      ClayTextField(label: widget.recurring ? 'Title' : 'Note (optional)', controller: _note),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [for (final k in moneyCategories) ClayChip(k, selected: _cat == k, onTap: () => setState(() => _cat = k))]),
      const SizedBox(height: 12),
      if (widget.recurring)
        ClayTextField(label: 'Day of month (1–28)', controller: _day, keyboardType: TextInputType.number)
      else
        Align(
          alignment: Alignment.centerLeft,
          child: ClayChip(longDate(toMs(DateTime.utc(_date.year, _date.month, _date.day))), icon: Icons.event_rounded, onTap: () async {
            final d = await pickDate(context, initial: _date);
            if (d != null) setState(() => _date = d);
          }),
        ),
      if (goals.isNotEmpty) ...[
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ClayChip('No goal', selected: _goalId == null, onTap: () => setState(() => _goalId = null)),
          for (final g in goals) ClayChip(g.goal.title, color: Color(g.goal.color), selected: _goalId == g.goal.id, onTap: () => setState(() => _goalId = g.goal.id)),
        ]),
      ],
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: c.rose, fontWeight: FontWeight.w700))),
      const SizedBox(height: 16),
      ClayButton('Save', onPressed: _save),
    ]);
  }
}
