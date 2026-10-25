import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'ai/ai_client.dart';
import 'ai/ai_features.dart';
import 'ai/token_budget.dart';
import 'db/database.dart';
import 'logic/guard_config.dart';
import 'native/native_bridge.dart';
import 'native/native_models.dart';
import 'native/secrets.dart';
import 'repos/goal_repo.dart';
import 'repos/money_repo.dart';
import 'repos/routine_repo.dart';
import 'repos/todo_repo.dart';
import 'services/activity_service.dart';
import 'services/backup_service.dart';
import 'services/native_sync.dart';
import 'services/stats_service.dart';
import 'services/time_service.dart';

final dbProvider = Provider<AppDb>((ref) => throw UnimplementedError('override in main'));
final bridgeProvider = Provider((ref) => NativeBridge());
final secretsProvider = Provider((ref) => Secrets());

final aiClientProvider = Provider((ref) => AiClient(
      db: ref.watch(dbProvider),
      client: http.Client(),
      keyProvider: ref.watch(secretsProvider).claudeKey,
    ));
final aiFeaturesProvider = Provider((ref) => AiFeatures(ref.watch(aiClientProvider)));

final goalRepoProvider = Provider((ref) => GoalRepo(ref.watch(dbProvider)));
final todoRepoProvider = Provider((ref) => TodoRepo(ref.watch(dbProvider), ref.watch(goalRepoProvider),
    ai: ref.watch(aiClientProvider), features: ref.watch(aiFeaturesProvider)));
final moneyRepoProvider = Provider((ref) => MoneyRepo(ref.watch(dbProvider)));
final routineRepoProvider = Provider((ref) => RoutineRepo(ref.watch(dbProvider)));
final timeServiceProvider = Provider((ref) => TimeService(ref.watch(dbProvider), ref.watch(bridgeProvider)));
final activityServiceProvider = Provider((ref) => ActivityService(ref.watch(dbProvider), ref.watch(bridgeProvider)));
final statsServiceProvider = Provider((ref) => StatsService(ref.watch(dbProvider)));
final backupServiceProvider = Provider((ref) => BackupService(ref.watch(dbProvider), ref.watch(secretsProvider)));
final nativeSyncProvider = Provider((ref) {
  final s = NativeSync(ref.watch(dbProvider), ref.watch(bridgeProvider), ref.watch(goalRepoProvider), ref.watch(todoRepoProvider),
      ref.watch(routineRepoProvider), ref.watch(timeServiceProvider), ref.watch(secretsProvider));
  ref.onDispose(s.dispose);
  return s;
});

// ---- reactive data ----
final goalViewsProvider = StreamProvider<List<GoalView>>((ref) => ref.watch(goalRepoProvider).watchViews());
final todosProvider = StreamProvider<List<Todo>>((ref) => ref.watch(todoRepoProvider).watchAll());
final routinesProvider = StreamProvider<List<Routine>>((ref) => ref.watch(routineRepoProvider).watchAll());
final contactsProvider = StreamProvider<List<Contact>>((ref) => ref.watch(routineRepoProvider).watchContacts());

final settingProvider = StreamProvider.family<Object?, String>((ref, key) => ref.watch(dbProvider).watchSetting<Object>(key));

final userNameProvider = Provider((ref) => (ref.watch(settingProvider('user.name')).value as String?) ?? 'Santanu');
final aboutMeProvider = Provider((ref) => (ref.watch(settingProvider('user.about')).value as String?) ?? '');
final aiOffProvider = Provider((ref) => ref.watch(settingProvider('ai.off')).value == true);
final themeModeSettingProvider = Provider((ref) => (ref.watch(settingProvider('theme')).value as String?) ?? 'system');

final guardSettingsProvider = StreamProvider<GuardSettings>((ref) =>
    ref.watch(dbProvider).watchSetting<Map<String, dynamic>>('guard').map(GuardSettings.fromJson));

final nativeStatusProvider = FutureProvider.autoDispose<NativeStatus>((ref) => ref.watch(bridgeProvider).status());

final budgetProvider = FutureProvider.autoDispose<({int cap, Map<String, int> byFeature})>((ref) async {
  final db = ref.watch(dbProvider);
  ref.watch(settingProvider('ai.budget'));
  final b = TokenBudget(db);
  // re-read whenever usage changes
  await db.select(db.aiUsage).get();
  return (cap: await b.cap(), byFeature: await b.usedThisMonthByFeature());
});

final aiReadyProvider = FutureProvider.autoDispose<bool>((ref) {
  ref.watch(aiOffProvider);
  return ref.watch(aiClientProvider).isEnabled();
});
