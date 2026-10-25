# Build plan

Build in this order. Each phase ends with a working APK and the checks below. Don't start a phase until the
previous one passes. Items marked **(device)** need a real Android phone; write what you did and what the
user must test in `docs/TEST_LOG.md`.

Recommended test phone settings: Developer options on, USB debugging on, battery = Unrestricted for the app.
Useful commands:
```bash
adb shell am kill com.teqsonic.goalcompass                 # kill the app process (alarms must still fire)
adb shell dumpsys deviceidle force-idle                     # force Doze
adb shell dumpsys deviceidle unforce
adb shell dumpsys alarm | grep goalcompass                  # see armed alarms
adb logcat -s GoalCompass                                   # native logs (use this tag in Kotlin)
```

---

## Phase 0 — Skeleton (half a day)
- `flutter create --org com.teqsonic --project-name goal_compass --platforms android .`
- Packages from `docs/ARCHITECTURE.md` §2; bundle Fredoka + Nunito fonts.
- `ClayTokens`, `ClayTheme` (light/dark), `ClayContainer`, `ClayButton`, `ClayChip`, `ClayProgressRing`,
  `ClayTextField`, bottom nav, go_router with empty screens.
- Drift database with all tables from `docs/ARCHITECTURE.md` §4, schema v1, DAOs, `settings` helper.
- `NativeBridge` Dart class + Kotlin `NativeBridgePlugin` with `status()` and `open()` only.
- Setup checklist screen (reads `status()`).

**Checks:** app opens in light and dark; a widget gallery screen (debug only) shows every Clay widget;
DB round-trip test passes; checklist opens each settings screen and refreshes on return.

## Phase 1 — Goals, todos, local scoring (1–2 days)
- Goals CRUD, stages CRUD, todos CRUD with recurrence; pace maths (`pace.dart`) with tests.
- `local_scorer.dart` with 20-case test table; score badge + reason on add.
- Todo sorting rule (PRD F2.3) with tests.
- Dashboard v1: "Do this now", goals strip, todo counts.

**Checks:** create 2 goals, 4 stages, 10 todos without network; pace statuses match tests; recurring todo
regenerates after completion.

## Phase 2 — Claude integration (1–2 days)
- Secure key storage, *Test key* (cheapest possible call: Haiku, `max_tokens` 1).
- `AiClient`, `TokenBudget`, `ai_cache`, `ai_usage`, budget meter in Settings, AI off switch.
- A1 plan + review screen; A2 digest; A3 batched alignment with local-first routing; A4 replan.
- Mock HTTP in tests: parse tool_use, invalid items dropped, 429 retry once, budget stops background calls at 80%.

**Checks:** plan for a real goal costs < 2,500 tokens total (see `ai_usage`); adding the same todo twice
makes 1 AI call; adding 5 lines at once makes 1 AI call; airplane mode → clear error, nothing lost.

## Phase 3 — Alerts over any screen (2 days)
- Kotlin `AlertScheduler`, `AlertReceiver`, `BootReceiver`, notification channel, notification actions.
- `GuardAccessibilityService` with overlay banners only (no nudges yet); `NativeSync` service in Dart.
- Todo reminders + daily focus alert + stage-due alert.

**Checks (device):** reminder at +2 min fires with app killed and screen off; with Doze forced; after reboot;
banner shows over YouTube when accessibility is on; *Done* on the notification marks the todo done next time
the app opens; missed alert after reboot shows once.

## Phase 4 — Wake-up routine + escalation (2–3 days)
- Routine editor, contacts, message template, WhatsApp settings screen with setup notes and *Send test*.
- `WakeScheduler` (`setAlarmClock`), `WakeRingService`, `WakeActivity` + Flutter `/wake` proof screen
  (walk with `StepProof`, type, maths), snooze, `/morning` screen.
- `EscalationReceiver` → `EscalationWorker` → `WhatsAppSender` → `SmsSender` fallback; `event_log` entries.

**Checks (device):** alarm at +2 min rings over the lock screen with the app killed; walking 30 steps stops it;
with no proof, WhatsApp message arrives at grace time; with mobile data off, SMS arrives instead;
after a reboot the next day's alarm is still armed; turning the routine off removes it from `dumpsys alarm`.

## Phase 5 — Time tracking (2–3 days)
- `UsageReader` (Kotlin) + `aggregate` WorkManager job + cursor; built-in package→category map (≈150 apps)
  in `assets/app_categories.json`; user overrides.
- `ContentCapture` in the accessibility service (allow-list only) → content items; `categorizer.dart`
  keyword/channel/domain rules; A5 daily batch; channel rule learning.
- Health Connect steps/distance/exercise (fallback step counter); manual focus sessions + notification action
  + quick-settings tile.
- Time screen (today/week), `daily_rollup`, 90-day retention job.

**Checks (device):** after a day of normal use, totals within ±5% of Digital Wellbeing; a Flutter tutorial on
YouTube counts as learning, a comedy clip as entertainment; steps match Google Fit/Samsung Health ±5%.

## Phase 6 — Nudges + Shorts blocker (1–2 days)
- `NudgeEngine` with rules from `setGuardConfig`, top tasks from `setTopTasks`, templates from `docs/AI.md`;
  snooze/escalate logic; quiet hours; deny-list; `nudge_log`.
- `ShortsDetector` with id lists from config; per-app toggles; blocked counter.
- Focus guard screen + *Test nudge*.

**Checks (device):** 15 min on Instagram in focus hours with a ≥ 70 todo open → banner; *5 more min* twice then
escalated nudge; no nudge in quiet hours or during a call; Shorts/Reels/shorts-URL in Chrome are blocked;
nudges obeyed % shows on dashboard.

## Phase 7 — Money (1 day)
- Entries, recurring entries, month view, money-goal pace ("need ₹X/month"), CSV export.

**Checks:** Indian number format correct; month totals match a test fixture; money goal % feeds the goal ring.

## Phase 8 — Dashboard v2 + weekly review (1 day)
- Full dashboard per PRD F6; streaks; A6 weekly review + numbers-only fallback.

**Checks:** dashboard opens < 300 ms with 90 days of data (seed script in `test/fixtures`); review costs
< 1,500 tokens.

## Phase 9 — Backup, polish, release build (1 day)
- Encrypted export/import, daily local snapshots, restore list.
- Release signing: create a keystore once, keep it outside the repo, `key.properties` in `.gitignore`.
  Always install updates over the existing app (uninstall deletes data).
- Final pass: empty states, error copy, reduce-motion, dark mode, 360-dp-wide phone layout.

**Checks:** export → uninstall → reinstall → import restores everything and re-arms alarms;
`flutter build apk --release` succeeds; app size < 40 MB.

---

## Optional: build the APK on GitHub (no local Android SDK)

`.github/workflows/build.yml`:
```yaml
name: Build APK
on: [push, workflow_dispatch]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: 17 }
      - uses: subosito/flutter-action@v2
        with: { channel: stable, cache: true }
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v4
        with: { name: goal-compass-apk, path: build/app/outputs/flutter-apk/app-release.apk }
```
For a signed release in CI, add the keystore as a base64 secret and decode it in a step; otherwise CI builds
use the debug key (fine for personal use, but then always install CI builds over CI builds).

## Known limits (tell the user, don't try to "fix")
- Work done on a laptop isn't visible to the phone: use focus sessions.
- YouTube/Instagram can rename screen ids in updates; ids are editable in Focus guard → Advanced.
- Xiaomi/Realme/Oppo/Vivo/OnePlus need Autostart + battery Unrestricted, or the OS may kill the service.
- WhatsApp escalation needs a Cloud API number and an approved template; SMS is the always-works fallback.
