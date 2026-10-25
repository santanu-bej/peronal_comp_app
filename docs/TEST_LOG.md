# Test log

## Verified in the build sandbox (no Android SDK, no device)
- `flutter analyze`: clean. `flutter test`: 76 tests pass (pace, local scorer 20-case table, todo sort, recurrence,
  nudge rules, categoriser, money format/maths, AiClient with mocked HTTP: tool_use parsing, invalid items dropped,
  429 retry once, 401, offline, cache hits, budget at 80%/100%, batching; repo flows; backup encrypt/restore;
  alert builder; time calc; widget smoke at 360 dp, light and dark).
- Kotlin native layer compiled with kotlinc against the Android 14 API jar and Flutter embedding jar
  (androidx classes were stubbed because Google Maven is blocked in the sandbox): no compile errors.
- NOT done here: `flutter build apk --release` (needs the Android SDK; run it locally or via
  `.github/workflows/build.yml`), and everything marked (device) below.

## Phase 0
- [ ] App opens in light and dark. More → Settings → Widget gallery shows every Clay widget.
- [ ] Setup checklist: each Fix button opens the right settings screen; rows refresh on return.

## Phase 1
- [ ] Create 2 goals, 4 stages, 10 todos with airplane mode on. Pace chips match expectations.
- [ ] Recurring todo (daily) regenerates when completed.

## Phase 2
- [ ] Plan with AI on a real goal: check Settings → AI usage; one plan should be well under 2,500 tokens.
- [ ] Add the same todo twice → 1 AI call. Paste 5 lines → 1 AI call. Airplane mode → clear error, input kept.

## Phase 3 (device)
- [ ] Todo reminder at +2 min fires with the app killed (`adb shell am kill com.teqsonic.goalcompass`), screen off.
- [ ] Same with `adb shell dumpsys deviceidle force-idle`.
- [ ] Same after a reboot (and a missed alert shows once as "Missed: …").
- [ ] Banner shows over YouTube with Accessibility on (Android 13+: App info → ⋮ → Allow restricted settings first).
- [ ] Notification *Done* marks the todo done next time the app opens.

## Phase 4 (device)
- [ ] Alarm at +2 min rings over the lock screen with the app killed; walking 30 steps stops it.
- [ ] No proof → WhatsApp message arrives at grace time. Mobile data off → SMS arrives instead.
- [ ] After reboot the next day's alarm is still armed (`adb shell dumpsys alarm | grep goalcompass`).
- [ ] Turning the routine off removes it from `dumpsys alarm`.
- [ ] Routines → Test escalation sends to the first contact.

## Phase 5 (device)
- [ ] After a day of use, Time totals are within ±5% of Digital Wellbeing.
- [ ] A Flutter tutorial on YouTube counts as learning; a comedy clip as entertainment.
- [ ] Steps match Google Fit / Samsung Health ±5%.
- [ ] Focus session from the quick-settings tile and the notification Stop action.

## Phase 6 (device)
- [ ] 15 min on Instagram in focus hours with a ≥ 70 todo open → banner; *5 more min* twice, then escalated nudge.
- [ ] No nudge in quiet hours or during a call. Shorts/Reels/shorts URL in Chrome are blocked.
- [ ] "Nudges obeyed %" shows on the dashboard.

## Phase 7–9
- [ ] Indian number format; month totals match; money goal % feeds the goal ring.
- [ ] Dashboard opens quickly with 90 days of data.
- [ ] Export → uninstall → reinstall → import restores everything and re-arms alarms.
- [ ] Release signing: create a keystore, put `android/key.properties` (storeFile, storePassword, keyAlias, keyPassword)
      next to it, never commit either. Always install updates over the existing app.
