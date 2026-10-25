import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/providers.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});
  @override
  ConsumerState<BackupScreen> createState() => _S();
}

class _S extends ConsumerState<BackupScreen> {
  bool _busy = false;
  List<File> _snaps = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final s = await ref.read(backupServiceProvider).snapshots();
    if (mounted) setState(() => _snaps = s);
  }

  Future<String?> _askPass(String title, {bool confirm = false}) async {
    final a = TextEditingController(), b = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: a, obscureText: true, decoration: const InputDecoration(labelText: 'Passphrase')),
          if (confirm) TextField(controller: b, obscureText: true, decoration: const InputDecoration(labelText: 'Repeat passphrase')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (a.text.length < 6 || (confirm && a.text != b.text)) return;
              Navigator.pop(ctx, a.text);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _export() async {
    final pass = await _askPass('Choose a passphrase (6+ chars)', confirm: true);
    if (pass == null) return;
    setState(() => _busy = true);
    try {
      final f = await ref.read(backupServiceProvider).exportToFile(pass);
      await SharePlus.instance.share(ShareParams(files: [XFile(f.path)], text: 'Goal Compass backup'));
    } catch (e) {
      if (mounted) toast(context, 'Export failed: $e');
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _import() async {
    final r = await FilePicker.pickFile();
    if (r == null || r.path == null) return;
    final bytes = await File(r.path!).readAsBytes();
    final pass = await _askPass('Backup passphrase');
    if (pass == null || !mounted) return;
    if (!await confirm(context, 'Replace everything?', 'All current data on this phone is replaced by the backup.', yes: 'Restore')) return;
    setState(() => _busy = true);
    try {
      await ref.read(backupServiceProvider).importFile(bytes, pass);
      await ref.read(nativeSyncProvider).syncNow();
      if (mounted) toast(context, 'Restored. Alarms and alerts re-armed.');
    } catch (e) {
      if (mounted) toast(context, e.toString());
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _restoreSnap(File f) async {
    if (!await confirm(context, 'Restore this snapshot?', 'All current data is replaced.', yes: 'Restore')) return;
    try {
      await ref.read(backupServiceProvider).restoreSnapshot(f);
      await ref.read(nativeSyncProvider).syncNow();
      if (mounted) toast(context, 'Restored');
    } catch (e) {
      if (mounted) toast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ClayScreen(title: 'Backup', back: true, bottomPad: 40, children: [
      ClayContainer(child: Text('Everything except API keys is saved to one encrypted .gcbak file. Share it to Drive or WhatsApp. Always install app updates over the existing app: uninstalling deletes data.', style: t.bodyMedium)),
      const SizedBox(height: 16),
      ClayButton('Export backup', icon: Icons.upload_rounded, busy: _busy, onPressed: _export),
      const SizedBox(height: 10),
      ClayButton('Import backup', icon: Icons.download_rounded, kind: ClayButtonKind.soft, onPressed: _busy ? null : _import),
      const SectionTitle('Daily snapshots (keeps 14)'),
      ClayButton('Snapshot now', kind: ClayButtonKind.soft, onPressed: () async { await ref.read(backupServiceProvider).snapshotNow(); await _refresh(); }),
      const SizedBox(height: 12),
      if (_snaps.isEmpty) const EmptyState(text: 'No snapshots yet. One is taken every night.'),
      for (final f in _snaps)
        ClayRow(
          icon: Icons.history_rounded,
          title: f.path.split('/').last.replaceAll('snapshot-', '').replaceAll('.gcbak', ''),
          subtitle: '${(f.lengthSync() / 1024).round()} KB · ${shortDate(f.lastModifiedSync().millisecondsSinceEpoch)}',
          trailing: TextButton(onPressed: () => _restoreSnap(f), child: const Text('Restore')),
        ),
    ]);
  }
}
