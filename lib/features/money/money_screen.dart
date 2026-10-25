import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../core/db/database.dart';
import '../../core/logic/money.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/money_format.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/clay_progress.dart';
import '../../core/widgets/screen.dart';
import '../goals/goals_screen.dart';
import 'money_sheet.dart';

class MoneyScreen extends ConsumerStatefulWidget {
  const MoneyScreen({super.key});
  @override
  ConsumerState<MoneyScreen> createState() => _S();
}

class _S extends ConsumerState<MoneyScreen> {
  late int _y, _m;
  @override
  void initState() {
    super.initState();
    final d = nowIst();
    _y = d.year;
    _m = d.month;
  }

  void _shift(int by) {
    final d = DateTime(_y, _m + by);
    setState(() { _y = d.year; _m = d.month; });
  }

  Future<void> _export() async {
    final csv = await ref.read(moneyRepoProvider).csv();
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/goal-compass-money.csv')..writeAsStringSync(csv);
    await SharePlus.instance.share(ShareParams(files: [XFile(f.path)]));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final repo = ref.watch(moneyRepoProvider);
    final target = (ref.watch(settingProvider('money.monthlyTargetPaise')).value as int?) ?? 0;
    final goals = (ref.watch(goalViewsProvider).value ?? []).where((g) => g.goal.type == 'money').toList();
    final recurring = ref.watch(_recurringProvider).value ?? [];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return ClayScreen(
      title: 'Money',
      back: true,
      bottomPad: 40,
      actions: [ClayIconButton(Icons.add_rounded, tooltip: 'Add entry', onPressed: () => showMoneySheet(context))],
      children: [
        StreamBuilder<List<MoneyEntry>>(
          stream: repo.watchMonth(_y, _m),
          builder: (context, snap) {
            final rows = snap.data ?? [];
            final tot = monthTotals(rows.map((e) => (kind: e.kind, amountPaise: e.amountPaise)));
            final byCat = <String, int>{};
            for (final r in rows.where((r) => r.kind == 'expense')) {
              byCat[r.category] = (byCat[r.category] ?? 0) + r.amountPaise;
            }
            final maxCat = byCat.values.fold<int>(1, (a, b) => a > b ? a : b);
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                IconButton(onPressed: () => _shift(-1), icon: const Icon(Icons.chevron_left_rounded)),
                Expanded(child: Center(child: Text('${months[_m - 1]} $_y', style: t.titleLarge))),
                IconButton(onPressed: () => _shift(1), icon: const Icon(Icons.chevron_right_rounded)),
              ]),
              ClayContainer(
                child: Column(children: [
                  Row(children: [
                    _Stat('Income', formatPaise(tot.income), c.mint),
                    _Stat('Expense', formatPaise(tot.expense), c.rose),
                    _Stat('Saved', formatPaise(tot.saved), c.peach),
                  ]),
                  if (target > 0) ...[
                    const SizedBox(height: 14),
                    ClayProgressBar(value: tot.saved / target, color: c.peach),
                    const SizedBox(height: 6),
                    Align(alignment: Alignment.centerLeft, child: Text('Target ${formatPaise(target)}/month', style: t.bodySmall)),
                  ],
                ]),
              ),
              TextButton(
                onPressed: () async {
                  final ctrl = TextEditingController(text: target == 0 ? '' : (target ~/ 100).toString());
                  final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                    title: const Text('Monthly saving target (₹)'),
                    content: TextField(controller: ctrl, keyboardType: TextInputType.number),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save'))],
                  ));
                  if (ok == true) await ref.read(dbProvider).setSetting('money.monthlyTargetPaise', (parseRupeesToPaise(ctrl.text) ?? 0));
                },
                child: const Text('Set monthly target'),
              ),
              if (goals.isNotEmpty) ...[const SectionTitle('Money goals'), for (final g in goals) GoalCard(v: g)],
              if (byCat.isNotEmpty) ...[
                const SectionTitle('Spending by category'),
                for (final e in (byCat.entries.toList()..sort((a, b) => b.value.compareTo(a.value))))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Expanded(child: Text(e.key, style: t.bodyMedium)), Text(formatPaise(e.value), style: t.bodyMedium)]),
                      const SizedBox(height: 4),
                      ClayProgressBar(value: e.value / maxCat, color: c.rose, height: 10),
                    ]),
                  ),
              ],
              const SectionTitle('Entries'),
              if (rows.isEmpty) const EmptyState(text: 'No entries this month.'),
              for (final r in rows)
                Dismissible(
                  key: ValueKey(r.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => repo.delete(r.id),
                  background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: Icon(Icons.delete_rounded, color: c.rose)),
                  child: ClayRow(
                    title: r.note ?? r.category,
                    subtitle: '${shortDate(r.date)} · ${r.category} · ${r.kind}',
                    trailing: Text('${r.kind == 'expense' ? '-' : '+'}${formatPaise(r.amountPaise)}', style: TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 16, color: r.kind == 'expense' ? c.rose : c.ink)),
                  ),
                ),
            ]);
          },
        ),
        SectionTitle('Recurring', trailing: ClayIconButton(Icons.add_rounded, tooltip: 'Add recurring', onPressed: () => showMoneySheet(context, recurring: true))),
        if (recurring.isEmpty) Text('Salary, rent, staff pay: added automatically on their day.', style: t.bodySmall),
        for (final r in recurring)
          ClayRow(
            title: r.title,
            subtitle: 'Day ${r.dayOfMonth} · ${r.kind} · ${formatPaise(r.amountPaise)}',
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              ClaySwitch(value: r.enabled, onChanged: (v) => repo.setRecurringEnabled(r.id, v)),
              IconButton(onPressed: () => repo.deleteRecurring(r.id), icon: Icon(Icons.delete_outline_rounded, color: c.rose)),
            ]),
          ),
        const SizedBox(height: 16),
        ClayButton('Export CSV', icon: Icons.table_chart_rounded, kind: ClayButtonKind.soft, onPressed: _export),
      ],
    );
  }
}

final _recurringProvider = StreamProvider.autoDispose((ref) => ref.watch(moneyRepoProvider).watchRecurring());

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(height: 4),
          FittedBox(child: Text(value, style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 18))),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ]),
      );
}
