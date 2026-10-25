import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/db/database.dart';
import 'package:goal_compass/core/providers.dart';
import 'package:goal_compass/core/theme/clay_theme.dart';
import 'package:goal_compass/core/theme/clay_tokens.dart';
import 'package:goal_compass/features/goals/goals_screen.dart';
import 'package:goal_compass/features/settings/gallery_screen.dart';
import 'package:goal_compass/features/todos/todos_screen.dart';

Widget app(AppDb db, Widget home, {bool dark = false}) => ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: MaterialApp(theme: buildClayTheme(dark ? ClayColors.dark_ : ClayColors.light), home: home),
    );

void main() {
  for (final dark in [false, true]) {
    testWidgets('gallery renders (dark=$dark)', (t) async {
      final db = AppDb(NativeDatabase.memory());
      await t.pumpWidget(app(db, const GalleryScreen(), dark: dark));
      await t.pump(const Duration(milliseconds: 500));
      expect(tester(t), isNull);
      expect(find.text('Primary'), findsOneWidget);
      await db.close();
    });
  }

  testWidgets('360dp wide goals + todos empty states render', (t) async {
    t.view.physicalSize = const Size(360 * 3, 800 * 3);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    final db = AppDb(NativeDatabase.memory());
    await t.pumpWidget(app(db, const GoalsScreen()));
    await t.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('No goals yet'), findsOneWidget);
    await t.pumpWidget(app(db, const TodosScreen()));
    await t.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('No todos here'), findsOneWidget);
    await db.close();
    await t.pumpWidget(const SizedBox());
  });
}

Object? tester(WidgetTester t) => t.takeException();
