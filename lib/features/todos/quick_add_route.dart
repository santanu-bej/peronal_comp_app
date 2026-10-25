import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'add_todo_sheet.dart';
import 'todos_screen.dart';

/// Target of goalcompass://add (notification action / launcher shortcut): opens Todo with the add sheet.
class QuickAddRoute extends StatefulWidget {
  const QuickAddRoute({super.key});
  @override
  State<QuickAddRoute> createState() => _S();
}

class _S extends State<QuickAddRoute> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showAddTodoSheet(context);
      if (mounted) context.go('/todos');
    });
  }

  @override
  Widget build(BuildContext context) => const TodosScreen();
}
