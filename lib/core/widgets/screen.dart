import 'package:flutter/material.dart';
import '../theme/clay_tokens.dart';
import 'clay_controls.dart';

/// Standard scrolling page: big title, optional actions, 20px side padding, room for the floating nav.
class ClayScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final List<Widget> actions;
  final bool back;
  final Widget? bottom;
  final double bottomPad;
  final Future<void> Function()? onRefresh;
  const ClayScreen({super.key, required this.title, required this.children, this.actions = const [], this.back = false, this.bottom, this.bottomPad = 120, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      padding: EdgeInsets.fromLTRB(ClaySpace.screenPad, 8, ClaySpace.screenPad, bottomPad),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            if (back) Padding(padding: const EdgeInsets.only(right: 12), child: ClayIconButton(Icons.arrow_back_rounded, tooltip: 'Back', onPressed: () => Navigator.of(context).maybePop())),
            Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineLarge)),
            ...actions,
          ]),
        ),
        ...children,
      ],
    );
    return Scaffold(
      body: SafeArea(child: onRefresh == null ? list : RefreshIndicator(onRefresh: onRefresh!, child: list)),
      bottomNavigationBar: bottom,
    );
  }
}

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

Future<bool> confirm(BuildContext context, String title, String body, {String yes = 'Yes'}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(yes)),
      ],
    ),
  );
  return r == true;
}

Future<DateTime?> pickDate(BuildContext context, {DateTime? initial, DateTime? first}) => showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: first ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
