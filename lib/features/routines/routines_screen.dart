import 'dart:convert';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../core/repos/routine_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

final _historyProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.eventLog)..where((e) => e.source.isIn(['wake', 'escalation']))..orderBy([(e) => OrderingTerm.desc(e.at)])..limit(40)).watch();
});

class RoutinesScreen extends ConsumerStatefulWidget {
  const RoutinesScreen({super.key});
  @override
  ConsumerState<RoutinesScreen> createState() => _S();
}

class _S extends ConsumerState<RoutinesScreen> {
  Routine? _r;
  final _msg = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    ref.read(routineRepoProvider).ensureWake().then((r) {
      _r = r;
      _msg.text = WakeConfig.fromJson(r.configJson).message;
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    if (!_loaded) return const ClayScreen(title: 'Routines', back: true, children: []);
    final repo = ref.read(routineRepoProvider);
    final r = (ref.watch(routinesProvider).value ?? []).where((x) => x.id == _r!.id).firstOrNull ?? _r!;
    final cfg = WakeConfig.fromJson(r.configJson);
    final contacts = ref.watch(contactsProvider).value ?? [];
    final history = ref.watch(_historyProvider).value ?? [];
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    Future<void> setCfg(WakeConfig n) => repo.save(r.id, config: n);

    return ClayScreen(title: 'Routines', back: true, bottomPad: 40, children: [
      ClayContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text('Wake up', style: t.titleLarge)),
            ClaySwitch(value: r.enabled, onChanged: (v) async {
              if (v && contacts.isEmpty) toast(context, 'Tip: add at least one escalation contact below.');
              await repo.save(r.id, enabled: v);
            }),
          ]),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final p = r.timeHhmm.split(':').map(int.parse).toList();
              final x = await showTimePicker(context: context, initialTime: TimeOfDay(hour: p[0], minute: p[1]));
              if (x != null) await repo.save(r.id, time: hhmm(x.hour, x.minute));
            },
            child: Text(r.timeHhmm, style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 56)),
          ),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (var i = 0; i < 7; i++)
              ClayChip(dayNames[i], selected: (r.daysMask >> i) & 1 == 1, onTap: () => repo.save(r.id, daysMask: r.daysMask ^ (1 << i))),
          ]),
          const SizedBox(height: 16),
          Text('Proof to stop the alarm', style: t.labelLarge),
          const SizedBox(height: 6),
          Wrap(spacing: 8, children: [
            ClayChip('Walk 30 steps', selected: cfg.proof == 'walk', onTap: () => setCfg(cfg.copyWith(proof: 'walk'))),
            ClayChip('Type top task', selected: cfg.proof == 'type', onTap: () => setCfg(cfg.copyWith(proof: 'type'))),
            ClayChip('3 sums', selected: cfg.proof == 'maths', onTap: () => setCfg(cfg.copyWith(proof: 'maths'))),
          ]),
          const SizedBox(height: 16),
          Text('Snoozes (5 min each): ${cfg.snoozeMax}', style: t.labelLarge),
          Wrap(spacing: 8, children: [for (var i = 0; i <= 2; i++) ClayChip('$i', selected: cfg.snoozeMax == i, onTap: () => setCfg(cfg.copyWith(snoozeMax: i)))]),
          const SizedBox(height: 12),
          Text('Grace before escalation: ${cfg.graceMin} min', style: t.labelLarge),
          Wrap(spacing: 8, children: [for (final g in [5, 10, 15, 20, 30]) ClayChip('$g', selected: cfg.graceMin == g, onTap: () => setCfg(cfg.copyWith(graceMin: g)))]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: Text('Vibration', style: t.labelLarge)), ClaySwitch(value: cfg.vibrate, onChanged: (v) => setCfg(cfg.copyWith(vibrate: v)))]),
        ]),
      ),
      const SectionTitle('Escalation contacts (up to 3)'),
      for (final ct in contacts)
        ClayRow(
          icon: Icons.person_rounded,
          title: ct.name,
          subtitle: ct.phoneE164,
          trailing: IconButton(onPressed: () => repo.deleteContact(ct.id), icon: Icon(Icons.delete_outline_rounded, color: c.rose)),
        ),
      if (contacts.length < 3) ClayButton('Add contact', icon: Icons.person_add_rounded, kind: ClayButtonKind.soft, onPressed: () => _addContact(context)),
      const SizedBox(height: 14),
      Text('Send via', style: t.labelLarge),
      const SizedBox(height: 6),
      Wrap(spacing: 8, children: [
        ClayChip('WhatsApp', selected: cfg.channel == 'whatsapp', onTap: () => setCfg(cfg.copyWith(channel: 'whatsapp'))),
        ClayChip('SMS', selected: cfg.channel == 'sms', onTap: () => setCfg(cfg.copyWith(channel: 'sms'))),
        ClayChip('WhatsApp then SMS', selected: cfg.channel == 'both', onTap: () => setCfg(cfg.copyWith(channel: 'both'))),
      ]),
      const SizedBox(height: 14),
      ClayTextField(label: 'Message (variables: {contact} {user} {minutes} {top_task})', controller: _msg, maxLines: 4, onChanged: (v) => setCfg(cfg.copyWith(message: v))),
      TextButton(onPressed: () { _msg.text = defaultWakeMessage; setCfg(cfg.copyWith(message: defaultWakeMessage)); }, child: const Text('Reset message')),
      const SizedBox(height: 8),
      ClayButton('Test escalation', icon: Icons.send_rounded, kind: ClayButtonKind.soft, onPressed: contacts.isEmpty ? null : () async {
        if (await confirm(context, 'Send now?', 'Sends the message to ${contacts.first.name} right now.', yes: 'Send')) {
          await ref.read(nativeSyncProvider).syncNow();
          await ref.read(bridgeProvider).testEscalation(r.id);
          if (context.mounted) toast(context, 'Sent. Result appears in history below.');
        }
      }),
      const SectionTitle('History'),
      if (history.isEmpty) Text('Rang, snoozed, proof done and escalations appear here.', style: t.bodySmall),
      for (final h in history)
        ClayRow(title: h.message, subtitle: '${shortDate(h.at)} ${timeLabel(h.at)} · ${h.source}', trailing: _lateChip(context, h)),
    ]);
  }

  Widget? _lateChip(BuildContext context, EventLogData h) {
    if (h.dataJson == null || h.message != 'Proof done') return null;
    final m = jsonDecode(h.dataJson!) as Map<String, dynamic>;
    final late = (m['lateMin'] as num?)?.toInt() ?? 0;
    final esc = m['escalated'] == true;
    final c = context.clay;
    return ClayChip(esc ? 'Escalated' : late <= 5 ? 'On time' : 'Late $late min', color: esc ? c.rose : late <= 5 ? c.mint : c.butter);
  }

  Future<void> _addContact(BuildContext context) async {
    final n = TextEditingController(), p = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add contact'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: n, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: p, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (10 digits or +country code)')),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add'))],
      ),
    );
    if (ok == true && n.text.trim().isNotEmpty && p.text.trim().length >= 10) await ref.read(routineRepoProvider).addContact(n.text, p.text, 'both');
  }
}
