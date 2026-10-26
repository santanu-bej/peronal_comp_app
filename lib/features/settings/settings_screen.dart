import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/ai/ai_client.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/clay_progress.dart';
import '../../core/widgets/screen.dart';

const _featureNames = {
  'plan': 'Goal plan',
  'digest': 'Goal digest',
  'align': 'Alignment score',
  'replan': 'Replan',
  'classify': 'Content classes',
  'review': 'Weekly review',
};

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _S();
}

class _S extends ConsumerState<SettingsScreen> {
  final _key = TextEditingController();
  final _name = TextEditingController();
  final _about = TextEditingController();
  final _budget = TextEditingController();
  bool _hasKey = false, _testing = false, _loaded = false;
  String? _msg;
  final _models = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(dbProvider);
    _name.text = (await db.getSetting<String>('user.name')) ?? 'Santanu';
    _about.text = (await db.getSetting<String>('user.about')) ?? '';
    _budget.text = ((await db.getSetting<int>('ai.budget')) ?? 400000).toString();
    for (final e in defaultModels.entries) {
      _models[e.key] = TextEditingController(text: (await db.getSetting<String>('ai.model.${e.key}')) ?? e.value);
    }
    _hasKey = (await ref.read(secretsProvider).aiKey())?.isNotEmpty == true;
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _saveKey() async {
    final k = _key.text.trim();
    setState(() { _testing = true; _msg = null; });
    final err = await ref.read(aiClientProvider).testKey(k);
    if (err == null) {
      await ref.read(secretsProvider).setAiKey(k);
      _key.clear();
      _hasKey = true;
      ref.invalidate(aiReadyProvider);
    }
    if (mounted) setState(() { _testing = false; _msg = err ?? 'Key works and is saved.'; });
  }

  Future<void> _testModel(String feature) async {
    final k = await ref.read(secretsProvider).aiKey();
    if (k == null) return setState(() => _msg = 'Add a key first.');
    final model = _models[feature]!.text.trim();
    final err = await ref.read(aiClientProvider).testKey(k, model: model);
    if (err == null) await ref.read(dbProvider).setSetting('ai.model.$feature', model);
    if (mounted) setState(() => _msg = err ?? '$model works.');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final db = ref.read(dbProvider);
    final off = ref.watch(aiOffProvider);
    final theme = ref.watch(themeModeSettingProvider);
    final budget = ref.watch(budgetProvider).value;
    if (!_loaded) return const ClayScreen(title: 'Settings', back: true, children: []);
    final used = budget?.byFeature.values.fold<int>(0, (a, b) => a + b) ?? 0;
    final cap = budget?.cap ?? 400000;

    return ClayScreen(title: 'Settings', back: true, bottomPad: 40, children: [
      const SectionTitle('About me'),
      ClayTextField(label: 'Name', controller: _name, onChanged: (v) => db.setSetting('user.name', v.trim())),
      const SizedBox(height: 12),
      ClayTextField(label: 'About me (≤ 200 chars)', controller: _about, maxLength: 200, maxLines: 3, onChanged: (v) => db.setSetting('user.about', v.trim())),
      const SectionTitle('AI'),
      ClayContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [Expanded(child: Text('AI off', style: t.titleMedium)), ClaySwitch(value: off, onChanged: (v) async { await db.setSetting('ai.off', v); ref.invalidate(aiReadyProvider); })]),
          Text('When off: local scoring only, no AI buttons, numbers-only weekly review.', style: t.bodySmall),
          const SizedBox(height: 14),
          ClayTextField(label: _hasKey ? 'Gemini API key (saved, enter new to replace)' : 'Gemini API key', controller: _key, obscure: true, hint: _hasKey ? '••••••••••••' : 'AIza…', onChanged: (_) => setState(() {})),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: ClayButton('Test & save key', kind: ClayButtonKind.soft, busy: _testing, onPressed: _key.text.trim().isEmpty ? null : _saveKey)),
            if (_hasKey) ...[const SizedBox(width: 10), Expanded(child: ClayButton('Remove', kind: ClayButtonKind.danger, onPressed: () async { await ref.read(secretsProvider).setAiKey(null); setState(() => _hasKey = false); ref.invalidate(aiReadyProvider); }))],
          ]),
          if (_msg != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_msg!, style: TextStyle(fontWeight: FontWeight.w700, color: _msg!.contains('works') || _msg!.contains('saved') ? c.mint : c.rose))),
        ]),
      ),
      const SectionTitle('Monthly token budget'),
      ClayContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$used of $cap tokens this month', style: t.titleMedium),
          const SizedBox(height: 8),
          ClayProgressBar(value: cap == 0 ? 0 : used / cap, color: used >= cap * 0.8 ? c.rose : c.mint),
          const SizedBox(height: 8),
          Text('At 80% background AI (digest, content classes, weekly review) stops. At 100% everything stops except a confirmed plan.', style: t.bodySmall),
          for (final e in (budget?.byFeature.entries ?? <MapEntry<String, int>>[]))
            Padding(padding: const EdgeInsets.only(top: 6), child: Row(children: [Expanded(child: Text(_featureNames[e.key] ?? e.key)), Text('${e.value}')])),
          const SizedBox(height: 12),
          ClayTextField(label: 'Cap (tokens)', controller: _budget, keyboardType: TextInputType.number, onChanged: (v) {
            final n = int.tryParse(v);
            if (n != null && n > 0) db.setSetting('ai.budget', n);
          }),
        ]),
      ),
      const SectionTitle('Models'),
      for (final e in _featureNames.entries)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(child: ClayTextField(label: e.value, controller: _models[e.key])),
            const SizedBox(width: 8),
            ClayButton('Test', kind: ClayButtonKind.soft, expand: false, onPressed: () => _testModel(e.key)),
          ]),
        ),
      const SectionTitle('Daily focus alert'),
      const _DailyFocus(),
      const SectionTitle('Theme'),
      Wrap(spacing: 8, children: [for (final m in ['system', 'light', 'dark']) ClayChip(m[0].toUpperCase() + m.substring(1), selected: theme == m, onTap: () => db.setSetting('theme', m))]),
      const SectionTitle('More'),
      ClayRow(icon: Icons.chat_rounded, title: 'WhatsApp escalation', trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push('/settings/whatsapp')),
      ClayRow(icon: Icons.checklist_rounded, title: 'Setup checklist', trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push('/setup')),
      ClayRow(icon: Icons.backup_rounded, title: 'Backup', trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push('/backup')),
      ClayRow(icon: Icons.receipt_long_rounded, title: 'Activity log', trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push('/log')),
      ClayRow(icon: Icons.notifications_rounded, title: 'Send test alert (in 10 s)', onTap: () => ref.read(bridgeProvider).testAlert(10)),
      ClayRow(icon: Icons.widgets_rounded, title: 'Widget gallery', subtitle: 'Debug', onTap: () => context.push('/gallery')),
    ]);
  }
}

class _DailyFocus extends ConsumerWidget {
  const _DailyFocus();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(dbProvider);
    final on = ref.watch(settingProvider('daily.enabled')).value != false;
    final time = (ref.watch(settingProvider('daily.time')).value as String?) ?? '08:00';
    return ClayContainer(
      child: Row(children: [
        Expanded(child: Text('Every morning at $time', style: Theme.of(context).textTheme.titleMedium)),
        TextButton(
          onPressed: () async {
            final p = time.split(':').map(int.parse).toList();
            final r = await showTimePicker(context: context, initialTime: TimeOfDay(hour: p[0], minute: p[1]));
            if (r != null) await db.setSetting('daily.time', '${r.hour.toString().padLeft(2, '0')}:${r.minute.toString().padLeft(2, '0')}');
          },
          child: const Text('Change'),
        ),
        ClaySwitch(value: on, onChanged: (v) => db.setSetting('daily.enabled', v)),
      ]),
    );
  }
}
