import 'package:drift/drift.dart';
import '../db/database.dart';

const defaultMonthlyBudget = 400000;
const userInitiatedFeatures = {'plan', 'replan', 'align'};

enum BudgetDecision { ok, needsConfirm, blocked }

/// Pure decision. 80%: background features (digest, classify, review) stop. 100%: all stop except
/// plan with confirmation.
BudgetDecision budgetDecision({required String feature, required int usedTokens, required int estimate, required int cap}) {
  final after = usedTokens + estimate;
  final background = !userInitiatedFeatures.contains(feature);
  if (background && usedTokens >= cap * 0.8) return BudgetDecision.blocked;
  if (after > cap) return feature == 'plan' ? BudgetDecision.needsConfirm : BudgetDecision.blocked;
  return BudgetDecision.ok;
}

class TokenBudget {
  final AppDb db;
  TokenBudget(this.db);

  Future<int> cap() async => (await db.getSetting<int>('ai.budget')) ?? defaultMonthlyBudget;

  Future<Map<String, int>> usedThisMonthByFeature({int? nowMs}) async {
    final now = DateTime.fromMillisecondsSinceEpoch(nowMs ?? DateTime.now().millisecondsSinceEpoch);
    final start = DateTime(now.year, now.month).millisecondsSinceEpoch;
    final rows = await (db.select(db.aiUsage)..where((u) => u.at.isBiggerOrEqualValue(start))).get();
    final out = <String, int>{};
    for (final r in rows) {
      out[r.feature] = (out[r.feature] ?? 0) + r.inputTokens + r.outputTokens + r.cacheWriteTokens;
    }
    return out;
  }

  Future<int> usedThisMonth({int? nowMs}) async =>
      (await usedThisMonthByFeature(nowMs: nowMs)).values.fold<int>(0, (a, b) => a + b);

  Future<BudgetDecision> canSpend(String feature, int estimate) async =>
      budgetDecision(feature: feature, usedTokens: await usedThisMonth(), estimate: estimate, cap: await cap());
}
