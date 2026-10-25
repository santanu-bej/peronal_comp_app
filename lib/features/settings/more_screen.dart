import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Widget row(IconData i, String t, String s, String path) => ClayRow(icon: i, title: t, subtitle: s, trailing: const Icon(Icons.chevron_right_rounded), onTap: () => context.push(path));
    return ClayScreen(title: 'More', children: [
      row(Icons.currency_rupee_rounded, 'Money', 'Income, expenses, savings', '/money'),
      row(Icons.alarm_rounded, 'Routines', 'Wake up and escalation', '/routines'),
      row(Icons.shield_rounded, 'Focus guard', 'Nudges and Shorts blocker', '/focus'),
      row(Icons.settings_rounded, 'Settings', 'AI, WhatsApp, theme', '/settings'),
      row(Icons.checklist_rounded, 'Setup checklist', 'Permissions and tips', '/setup'),
      row(Icons.backup_rounded, 'Backup', 'Export, import, snapshots', '/backup'),
      row(Icons.receipt_long_rounded, 'Activity log', 'What ran in the background', '/log'),
    ]);
  }
}
