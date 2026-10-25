import 'package:drift/drift.dart';

/// Schema v1 is the baseline. Add `if (from < 2) { await m.addColumn(...); }` steps here, one per version.
Future<void> migrate(Migrator m, int from, int to) async {
  // v1 → nothing to do yet.
}
