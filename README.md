# Goal Compass

Personal Android app (Flutter + Kotlin). Spec: `CLAUDE.md` and `docs/`. Manual checks: `docs/TEST_LOG.md`.

```bash
flutter pub get
dart run build_runner build
flutter analyze && flutter test
flutter build apk --release   # needs the Android SDK, or use .github/workflows/build.yml
```
