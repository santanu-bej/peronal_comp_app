# Architecture — Goal Compass

## 1. Shape

```
┌──────────────────────────── Flutter (Dart) ────────────────────────────┐
│  UI (features/*)  →  Riverpod providers  →  Repositories  →  Drift DB  │
│                                   │                                    │
│                         AiClient (Claude API)                          │
│                         NativeBridge (MethodChannel + EventChannel)    │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ config + snapshots (SharedPreferences / EncryptedSharedPreferences)
┌───────────────────────────── Kotlin (native) ──────────────────────────┐
│ GuardAccessibilityService  AlertScheduler  WakeAlarm*  Escalation*     │
│ UsageReader  BootReceiver  StepDetector                                │
└────────────────────────────────────────────────────────────────────────┘
```

Rule: **Dart decides, Kotlin executes.** Dart writes plans (what to alert, when, what rules) into native
storage. Kotlin runs them with no Flutter engine needed. Kotlin writes results (events, sessions, nudge
actions) into a native queue that Dart drains into Drift when the app is open or when a WorkManager job runs.

## 2. Stack

| Need | Package / tool | Why |
|---|---|---|
| State | `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator` | Testable, no context plumbing |
| Navigation | `go_router` | Deep links from notifications (`/wake`, `/todo/:id`) |
| Database | `drift` + `drift_flutter` + `sqlite3_flutter_libs` | Typed SQL, migrations, reactive queries |
| Charts | `fl_chart` | Donut, bars, line for pace |
| HTTP | `http` | Claude API + WhatsApp Cloud API; no SDK needed |
| Secrets | `flutter_secure_storage` | API keys |
| Background | `workmanager` | 15-min aggregation, daily jobs |
| Health | `health` (Health Connect) | Steps, distance, exercise sessions |
| Permissions | `permission_handler` | Runtime permissions; special ones go through NativeBridge |
| Fonts | bundled assets (Fredoka, Nunito) | Works offline; no runtime font fetch |
| Crypto for backup | `cryptography` | AES-GCM for the backup file |
| Share/files | `share_plus`, `file_picker` | Backup export/import |
| Testing | `flutter_test`, `mocktail` | Logic + repository tests |
| Native | Kotlin, `androidx.work`, `androidx.security:security-crypto`, `okhttp` | Runs without Flutter |

Android: `minSdk 26`, `targetSdk` = latest stable, Kotlin JVM target 17+. Portrait only.

## 3. Folders

```
lib/
  main.dart                     # init DB, providers, workmanager, router
  app.dart                      # MaterialApp.router + ClayTheme
  core/
    ai/        ai_client.dart, prompts.dart, schemas.dart, token_budget.dart, ai_cache.dart
    db/        database.dart, tables/*.dart, daos/*.dart, migrations.dart
    native/    native_bridge.dart, native_models.dart, event_drain.dart
    logic/     pace.dart, local_scorer.dart, categorizer.dart, nudge_rules.dart, recurrence.dart, money.dart
    theme/     clay_tokens.dart, clay_theme.dart
    widgets/   clay_container.dart, clay_button.dart, clay_chip.dart, clay_progress.dart, ...
    utils/     time.dart (IST helpers), money_format.dart, hash.dart
  features/
    onboarding/  dashboard/  goals/  todos/  routines/  time/  money/  focus/  settings/  backup/
android/app/src/main/kotlin/com/teqsonic/goalcompass/
    MainActivity.kt  NativeBridgePlugin.kt
    guard/       GuardAccessibilityService.kt, ShortsDetector.kt, ContentCapture.kt, NudgeEngine.kt, Overlay.kt
    alerts/      AlertScheduler.kt, AlertReceiver.kt, BootReceiver.kt
    wake/        WakeScheduler.kt, WakeReceiver.kt, WakeRingService.kt, WakeActivity.kt, StepProof.kt
    escalate/    EscalationReceiver.kt, EscalationWorker.kt, WhatsAppSender.kt, SmsSender.kt
    usage/       UsageReader.kt
    store/       NativeStore.kt (SharedPreferences JSON + EncryptedSharedPreferences), EventQueue.kt
test/  logic/*, ai/*, db/*
docs/
```

## 4. Database (Drift)

All ids are text UUIDs unless noted. Timestamps: `int` epoch ms UTC. Money: `int` paise.

| Table | Columns |
|---|---|
| `goals` | id, title, why, type(`general`/`money`), target_paise?, start_at, deadline_at, priority, color, status, digest?, digest_stale(bool), created_at, updated_at |
| `stages` | id, goal_id, title, done_when, due_at, weight(int 1–100), order_index, status(`open`/`done`/`dropped`), source(`ai`/`user`), align_score?, created_at, done_at? |
| `todos` | id, goal_id?, stage_id?, title, norm_hash, estimate_min, due_at?, remind_at?, recurrence(`none`/`daily`/`weekdays`/`weekly`), score?, score_source(`cache`/`rule`/`ai`), reason?, status(`open`/`done`/`dropped`), created_at, done_at? |
| `focus_sessions` | id, todo_id?, category, started_at, ended_at?, source(`manual`/`tile`/`notif`) |
| `routines` | id, kind(`wake`/`workout`/`sleep`/`deep_work`), title, time_hhmm, days_mask(int, bit0=Mon), enabled, config_json |
| `contacts` | id, name, phone_e164, channel(`whatsapp`/`sms`/`both`) |
| `app_categories` | package (pk), label, category, user_set(bool) |
| `usage_sessions` | id (int autoincrement), package, started_at, ended_at, category |
| `content_items` | id (int), package, title, channel_or_domain?, kind(`video`/`page`/`reels`/`feed`/`dm`), started_at, ended_at, category?, classified_by(`rule`/`ai`/`user`/`pending`), title_hash |
| `content_rules` | id, match_type(`keyword`/`channel`/`domain`), value, category |
| `activity_daily` | date (pk, `yyyy-MM-dd` IST), steps, distance_m, active_min, exercise_min |
| `money_entries` | id, goal_id?, date, amount_paise, kind(`income`/`expense`/`saving`), category, note?, recurring_id? |
| `money_recurring` | id, title, amount_paise, kind, category, day_of_month, goal_id?, enabled |
| `nudge_log` | id (int), at, type, package?, todo_id?, text, action(`opened`/`snoozed`/`dismissed`/`ignored`/`blocked`) |
| `event_log` | id (int), at, source(`wake`/`escalation`/`alert`/`guard`/`ai`/`sync`), level, message, data_json |
| `ai_cache` | key (pk = sha256 of kind+model+input), kind, response_json, created_at, expires_at? |
| `ai_usage` | id (int), at, feature, model, input_tokens, output_tokens, cache_read_tokens, cache_write_tokens |
| `daily_rollup` | date (pk), minutes_by_category_json, wasted_min, work_min, learning_min, top_apps_json |
| `settings` | key (pk), value_json |

Indexes: `todos(status, score)`, `usage_sessions(started_at)`, `content_items(started_at)`,
`money_entries(date)`, `nudge_log(at)`. Write `migrations.dart` from schema v1 with `stepByStep` migrations.

Retention: raw `usage_sessions` / `content_items` older than 90 days → `daily_rollup` then deleted
(nightly WorkManager job). `event_log` keeps 30 days. `ai_cache` keeps 180 days.

## 5. Native layer (Kotlin)

### 5.1 NativeBridge (MethodChannel `goalcompass/native`, EventChannel `goalcompass/events`)

| Method | Purpose |
|---|---|
| `status()` | accessibility on/running, usage access, notifications, exact alarm, full-screen intent, battery unrestricted, SMS permission, brand, sdk |
| `open(setting)` | `accessibility`, `usage_access`, `app_info`, `battery`, `exact_alarm`, `full_screen_intent`, `notifications` |
| `syncAlerts(list)` | Replace all reminder alerts `{id, atMs, title, body, kind, deepLink}` |
| `syncWake(list)` | Replace all wake routines `{id, hhmm, daysMask, proof, graceMin, snoozeMax, sound, message, contacts[], channel}` |
| `setGuardConfig(json)` | Nudge rules, focus/quiet hours, deny-list, blocker toggles, content allow-list |
| `setTopTasks(list)` | Snapshot of top 5 open todos `{id, title, score}` for nudge text (update on every todo change) |
| `setSecrets({whatsappToken, phoneNumberId, template, lang})` | Into EncryptedSharedPreferences |
| `readUsage(fromMs, toMs)` | App sessions from UsageStatsManager events |
| `drainEvents()` | Returns and clears the native event queue (nudge actions, wake events, content items, escalation results) |
| `wakeProofDone(routineId)` | Stop ringing, cancel escalations |
| `testEscalation(routineId)` / `testAlert(seconds)` / `testNudge()` | Manual tests from Settings |

Native → Dart events (EventChannel, only while app is open): `foregroundApp`, `nudgeAction`, `wakeState`.
When the app is closed, the same data goes into `EventQueue` (a JSON file in app storage, append-only,
max 5,000 lines) and is drained on next open or by the 15-min WorkManager job.

### 5.2 AlertScheduler (todo reminders, daily focus, stage due)
- `AlarmManager.setExactAndAllowWhileIdle(RTC_WAKEUP)`; fall back to `setAndAllowWhileIdle` if exact not allowed.
- One `PendingIntent` per alert id (`Intent.setData(Uri("goalcompass://alert/<id>"))`), `FLAG_IMMUTABLE`.
- `syncAlerts` cancels everything not in the new list, arms the rest. Stored as JSON in `NativeStore`.
- On fire: high-importance notification (channel `alerts`) **and** `GuardAccessibilityService.showBanner(...)`
  if the service is running. Notification actions: *Done*, *Snooze 15m* (handled natively, queued for Dart).
- `BootReceiver` (`BOOT_COMPLETED`, `MY_PACKAGE_REPLACED`, `TIME_SET`, `TIMEZONE_CHANGED`) re-arms all;
  alerts missed while off fire once as "Missed: …".

### 5.3 Wake alarm (F3)
- Schedule with **`AlarmManager.setAlarmClock()`** (exits Doze, shows the alarm icon; most reliable).
- `WakeReceiver` → starts `WakeRingService` (foreground service, type `mediaPlayback`) that plays the alarm
  sound on `USAGE_ALARM` stream at full volume with vibration, and posts a notification with a
  **full-screen intent** to `WakeActivity`.
- `WakeActivity` extends `FlutterActivity`, `showWhenLocked` + `turnScreenOn`, opens Dart route `/wake?id=…`
  (cached Flutter engine warmed in `MainActivity` when possible). The proof UI is Flutter; the step count for
  the *Walk* proof comes from native `StepProof` (`Sensor.TYPE_STEP_DETECTOR`, needs `ACTIVITY_RECOGNITION`).
- At ring time also arm **escalation** with `setAlarmClock()` at ring + grace. Snooze re-arms ringing at +5 min
  but never moves escalation.
- `wakeProofDone` → stop service, cancel escalation alarms, queue `wake_done` event, open `/morning`.
- If the Flutter UI can't start (rare), `WakeRingService` keeps ringing; proof can also be done from the
  notification's *Maths* fallback activity (pure native, 3 sums).

### 5.4 Escalation (F3)
- `EscalationReceiver` → enqueue expedited `EscalationWorker` (WorkManager, `setExpedited`, no network
  constraint) + acquire a 60 s wake lock.
- Worker: read contacts + secrets from `NativeStore`; for each contact:
  1. if channel has WhatsApp and network available → `WhatsAppSender` (OkHttp, 20 s timeout).
  2. if WhatsApp failed / no network / channel is SMS → `SmsSender` (`SmsManager.sendMultipartTextMessage`,
     with sent-status `PendingIntent`).
- Log each result into `EventQueue`; Dart shows it in the routine's history.

**WhatsApp Cloud API call** (no server needed):
```
POST https://graph.facebook.com/<GRAPH_VERSION>/<PHONE_NUMBER_ID>/messages
Authorization: Bearer <ACCESS_TOKEN>
Content-Type: application/json

{ "messaging_product": "whatsapp", "to": "91XXXXXXXXXX", "type": "template",
  "template": { "name": "wake_alert", "language": { "code": "en" },
    "components": [ { "type": "body", "parameters": [
      { "type": "text", "text": "Rahul" },        // {{1}} contact
      { "type": "text", "text": "Santanu" },      // {{2}} user
      { "type": "text", "text": "15" },           // {{3}} minutes late
      { "type": "text", "text": "Send invoice" }  // {{4}} top task
    ] } ] } }
```
Setup notes for the user (put these on the WhatsApp settings screen):
- Business-initiated messages must use an **approved template** (category *Utility*). Template body:
  `Hey {{1}}, {{2}} is still sleeping ({{3}} min after his alarm). He has "{{4}}" pending today. Please call him and wake him up!`
- Use a **permanent System User token**, not the 24-hour test token.
- The sending number can be Meta's free test number (it can message a handful of verified recipient
  numbers) or a separate SIM. It can't be the number used in the normal WhatsApp app at the same time.
- Keep `<GRAPH_VERSION>` a setting (default: current Graph API version at build time).
- SMS fallback always works offline; it costs normal SMS rates.

### 5.5 GuardAccessibilityService
Config in `res/xml/guard_service.xml`: events `typeWindowStateChanged|typeWindowContentChanged`,
`flagReportViewIds`, `canRetrieveWindowContent=true`, `notificationTimeout=250`, **no** `packageNames`
filter (it must see every foreground app for nudges). Keep work per event tiny:
- Track foreground package from `TYPE_WINDOW_STATE_CHANGED` (ignore SystemUI, keyboards, own app).
- **NudgeEngine**: per-session timer for the current package; category from the synced category map;
  apply rules from `setGuardConfig` + top tasks from `setTopTasks`; show banner; record action.
- **ShortsDetector** (only for YouTube, Instagram, browsers; throttle 300 ms; 1.2 s cool-down after a block):
  YouTube view ids `reel_recycler`, `reel_player_page_container`, `reel_watch_player`, `reel_watch_fragment_root`;
  Instagram `clips_viewer_view_pager`, `clips_viewer_container`, `clips_video_container`, `root_clips_layout`;
  browsers' address bar (`com.android.chrome:id/url_bar`, `com.brave.browser:id/url_bar`,
  `com.sec.android.app.sbrowser:id/location_bar_edit_text`, …) containing `youtube.com/shorts` or
  `instagram.com/reel`. Action: `GLOBAL_ACTION_BACK` + toast banner. Keep the id lists in `setGuardConfig`
  so they can be updated from Settings without a rebuild.
- **ContentCapture** (allow-list apps only): on content change, debounce 3 s, read YouTube title/channel
  nodes, browser title/domain, Instagram/Facebook screen kind; emit only when the value changes.
  Never read text fields, messages content or notifications.
- **Overlay**: `WindowManager` + `TYPE_ACCESSIBILITY_OVERLAY` (no `SYSTEM_ALERT_WINDOW` needed). Views built
  in Kotlin with the clay look (rounded 24dp, soft shadow, pastel). Banner at top with safe-area offset;
  buttons call back into NudgeEngine. Auto-hide: reminders 90 s, nudges 30 s, escalated nudge never.

### 5.6 UsageReader
`UsageStatsManager.queryEvents(from, to)`; pair `ACTIVITY_RESUMED`/`ACTIVITY_PAUSED`
(`MOVE_TO_FOREGROUND/BACKGROUND` on older APIs) per package into sessions; drop sessions < 3 s; close open
sessions at `SCREEN_NON_INTERACTIVE`. Returns `[{pkg, start, end}]`. Dart stores and categorises.

## 6. Background jobs (Dart, `workmanager`)

| Job | Frequency | Work |
|---|---|---|
| `aggregate` | every 15 min (min allowed) | drain native events, read usage since last cursor, categorise, update today's rollup, refresh `setTopTasks` |
| `daily_maintenance` | daily ~03:30 | recurring todos/money entries, retention roll-up, local snapshot backup, digest refresh if stale |
| `content_classify` | daily ~21:00, network required | one AI batch for pending content titles (≤ 50) |
| `weekly_review` | Sunday ~20:00, network required | one AI call, store result |

Also run `aggregate` on app resume. Jobs must be idempotent (cursor stored in `settings`).

## 7. Sync pattern (keeps native in step with the DB)

After any change to todos, goals, routines or settings, a debounced (500 ms) `NativeSync` service:
1. builds the full alert list (todo reminders, daily focus, stage due) → `syncAlerts`
2. builds wake routines → `syncWake`
3. builds guard config + category map → `setGuardConfig`
4. builds top 5 tasks → `setTopTasks`

Always full replacement, never incremental. Also run on app start and after restore.

## 8. Permissions (AndroidManifest)

`INTERNET`, `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM` (maxSdk 32), `USE_EXACT_ALARM`,
`USE_FULL_SCREEN_INTENT`, `RECEIVE_BOOT_COMPLETED`, `WAKE_LOCK`, `VIBRATE`, `FOREGROUND_SERVICE`,
`FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `PACKAGE_USAGE_STATS` (tools:ignore ProtectedPermissions),
`ACTIVITY_RECOGNITION`, `SEND_SMS`, `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`, `QUERY_ALL_PACKAGES`,
Health Connect read permissions for steps, distance, exercise; accessibility service declared with
`BIND_ACCESSIBILITY_SERVICE`, `exported="true"`.

Special-access permissions (accessibility, usage access, full-screen intent on Android 14+, exact alarm,
battery) can't be requested by dialog: the setup checklist opens the right settings screen and rechecks on resume.
Android 13+ sideloaded apps: accessibility shows "restricted setting" → app info → ⋮ → *Allow restricted settings*.
Put that hint on the checklist row.

## 9. Backup

- Export: all Drift tables (no secrets) → JSON → gzip → AES-GCM with a key derived (PBKDF2, 200k rounds)
  from a passphrase I type → `goal-compass-YYYY-MM-DD.gcbak` → share sheet.
- Import: pick file → passphrase → validate schema version → replace DB in a transaction → run NativeSync.
- Daily local snapshot (same format, device-generated key in secure storage) in app files; keep 14; restore from Settings.
