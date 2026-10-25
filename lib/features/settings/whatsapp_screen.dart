import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/screen.dart';

class WhatsappScreen extends ConsumerStatefulWidget {
  const WhatsappScreen({super.key});
  @override
  ConsumerState<WhatsappScreen> createState() => _S();
}

class _S extends ConsumerState<WhatsappScreen> {
  final _phone = TextEditingController(), _token = TextEditingController(), _template = TextEditingController(text: 'wake_alert');
  final _lang = TextEditingController(text: 'en'), _graph = TextEditingController(text: 'v21.0');
  bool _hasToken = false, _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(dbProvider);
    _phone.text = (await db.getSetting<String>('wa.phoneId')) ?? '';
    _template.text = (await db.getSetting<String>('wa.template')) ?? 'wake_alert';
    _lang.text = (await db.getSetting<String>('wa.lang')) ?? 'en';
    _graph.text = (await db.getSetting<String>('wa.graph')) ?? 'v21.0';
    _hasToken = (await ref.read(secretsProvider).whatsappToken())?.isNotEmpty == true;
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _save() async {
    final db = ref.read(dbProvider);
    await db.setSetting('wa.phoneId', _phone.text.trim());
    await db.setSetting('wa.template', _template.text.trim());
    await db.setSetting('wa.lang', _lang.text.trim());
    await db.setSetting('wa.graph', _graph.text.trim());
    if (_token.text.trim().isNotEmpty) {
      await ref.read(secretsProvider).setWhatsappToken(_token.text.trim());
      _token.clear();
      _hasToken = true;
    }
    await ref.read(nativeSyncProvider).syncNow();
    if (mounted) {
      setState(() {});
      toast(context, 'Saved');
    }
  }

  Future<void> _test() async {
    await _save();
    final wake = await ref.read(routineRepoProvider).ensureWake();
    final contacts = ref.read(contactsProvider).value ?? [];
    if (contacts.isEmpty) {
      if (mounted) toast(context, 'Add an escalation contact in Routines first.');
      return;
    }
    if (!mounted) return;
    if (await confirm(context, 'Send test message?', 'Sends the escalation message to ${contacts.first.name} now.', yes: 'Send')) {
      await ref.read(nativeSyncProvider).syncNow();
      await ref.read(bridgeProvider).testEscalation(wake.id);
      if (mounted) toast(context, 'Test sent. Check Activity log for the result.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (!_loaded) return const ClayScreen(title: 'WhatsApp', back: true, children: []);
    return ClayScreen(title: 'WhatsApp', back: true, bottomPad: 40, children: [
      ClayContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Setup notes', style: t.titleMedium),
          const SizedBox(height: 8),
          Text('• Business-initiated messages need an approved template (category Utility). Template body:\n'
              '  Hey {{1}}, {{2}} is still sleeping ({{3}} min after his alarm). He has "{{4}}" pending today. Please call him and wake him up!\n'
              '• Use a permanent System User token, not the 24-hour test token.\n'
              '• The sending number can be Meta’s free test number (a few verified recipients) or a separate SIM. It cannot be the number used in normal WhatsApp at the same time.\n'
              '• SMS fallback always works offline and costs normal SMS rates.', style: t.bodySmall),
        ]),
      ),
      const SizedBox(height: 16),
      ClayTextField(label: 'Phone number ID', controller: _phone, keyboardType: TextInputType.number),
      const SizedBox(height: 12),
      ClayTextField(label: _hasToken ? 'Access token (saved, enter new to replace)' : 'Access token', controller: _token, obscure: true),
      const SizedBox(height: 12),
      ClayTextField(label: 'Template name', controller: _template),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: ClayTextField(label: 'Language code', controller: _lang)),
        const SizedBox(width: 12),
        Expanded(child: ClayTextField(label: 'Graph API version', controller: _graph)),
      ]),
      const SizedBox(height: 20),
      ClayButton('Save', onPressed: _save),
      const SizedBox(height: 10),
      ClayButton('Send test', kind: ClayButtonKind.soft, icon: Icons.send_rounded, onPressed: _test),
    ]);
  }
}
