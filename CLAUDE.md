# CLAUDE.md — Goal Compass (Flutter)

You are building **Goal Compass**, a personal Android app that keeps one person (Santanu) moving toward his goals.
It plans goals with AI, checks every todo against those goals, tracks where his time and money go,
wakes him up (and asks a friend to call him if he doesn't get up), and interrupts him on any screen
when he is wasting time.

Personal use only. Android only. Installed as an APK, never published to Google Play.
That means: use any permission the feature needs (accessibility, usage access, SMS, full-screen intent),
and don't spend time on store policy, iOS, tablets, or localisation.

## Read these before writing code

| File | What it covers |
|---|---|
| `docs/PRD.md` | Every feature, the user stories and the acceptance criteria. The source of truth for behaviour. |
| `docs/ARCHITECTURE.md` | Stack, folders, database tables, native Android (Kotlin) parts, background jobs, permissions. |
| `docs/AI.md` | The Claude API client, every AI call (prompt, JSON schema, token budget), caching and local fallbacks. |
| `docs/DESIGN.md` | Claymorphism design system: tokens, the `Clay*` widgets, every screen. |
| `docs/BUILD_PLAN.md` | Build order in phases. Each phase has acceptance checks. Do the phases in order. |

## Hard rules

1. **Serverless.** No backend, no Firebase, no Supabase. All data lives on the phone (SQLite via Drift).
   The only network calls are: Claude API, WhatsApp Cloud API (wake escalation), and nothing else.
2. **AI is expensive; rules are free.** Every AI feature has a local path that runs first
   (cache, keyword rules, math). Call Claude only when the local path can't answer. Follow the token
   budgets in `docs/AI.md` exactly. Never send raw usage logs, full todo lists or full plans to the API:
   send the compact **goal digest** and aggregated numbers.
3. **Things that must work when the app is closed are native Kotlin**, not Dart: alarms, wake escalation,
   reminder alerts, the accessibility service (overlay nudges, Shorts blocker, foreground-app detection).
   Dart configures them through a MethodChannel and shared preferences; Kotlin runs them on its own.
   See `docs/ARCHITECTURE.md` → Native layer.
4. **Reliability over cleverness.** Every scheduled thing is rebuilt from the database (idempotent sync),
   re-armed after reboot and app update, and logged in `event_log` so failures can be seen in the app.
5. **Money is stored as integer paise.** Times are stored as UTC epoch milliseconds; shown in Asia/Kolkata.
6. **Secrets** (Claude API key, WhatsApp token) live in `flutter_secure_storage` (Dart) and
   EncryptedSharedPreferences (Kotlin). Never log them, never put them in the database or a backup file.
7. **No feature creep.** Build what `docs/PRD.md` lists. If something seems missing, add it to
   `docs/IDEAS.md` and ask, don't build it.

## Stack (summary)

Flutter stable (latest) · Dart 3 · Riverpod (with code generation) · go_router · Drift (SQLite) ·
fl_chart · flutter_secure_storage · http · workmanager · health (Health Connect) · permission_handler ·
Kotlin for the native layer. Use the latest stable version of each package at build time and run
`flutter pub outdated` once per phase. Full list with reasons: `docs/ARCHITECTURE.md`.

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after changing Drift tables or Riverpod providers
flutter analyze                                             # must be clean before finishing any task
flutter test                                                # unit tests for logic, scoring, schedulers
flutter build apk --release                                 # build/app/outputs/flutter-apk/app-release.apk
```

## How to work in this repo

- Work phase by phase from `docs/BUILD_PLAN.md`. Finish a phase's acceptance checks before starting the next.
- Pure logic (scoring rules, pace math, categoriser, nudge rules, token budget) goes in `lib/core/logic/`
  as plain Dart functions with unit tests. Widgets never contain business logic.
- Every AI call goes through `AiClient` (`lib/core/ai/`). No other file talks to the Claude API.
- Every native call goes through `NativeBridge` (`lib/core/native/`). No other file uses MethodChannels.
- When a native behaviour can't be tested on the emulator (accessibility, usage stats, SMS), write the
  manual test steps into the phase's checklist in `docs/BUILD_PLAN.md` and tell the user to run them.
- Keep files under ~300 lines. One feature = one folder in `lib/features/`.
- UI copy: short, plain English. The user is fine with light Hinglish in nudge messages only.

## Definition of done (every task)

`flutter analyze` clean · tests for any new logic pass · the APK builds · the feature's acceptance
criteria in `docs/PRD.md` are met · `event_log` shows what happened for anything that runs in the background.
