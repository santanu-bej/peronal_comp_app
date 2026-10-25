import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/db/database.dart';
import 'core/providers.dart';
import 'core/services/jobs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final db = AppDb();
  try {
    await initJobs();
  } catch (e) {
    await db.log('sync', 'Job registration failed: $e', level: 'error');
  }
  final onboarded = (await db.getSetting<bool>('onboarded')) == true;
  runApp(ProviderScope(
    overrides: [dbProvider.overrideWithValue(db)],
    child: GoalCompassApp(startOnboarding: !onboarded),
  ));
}
