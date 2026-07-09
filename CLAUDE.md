# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Ello — a voice-first productivity/wellbeing assistant (Flutter). The Dart package name is `voice_input` (defined in `pubspec.yaml`), not `ai_ello` — all internal imports use `package:voice_input/...`. The repo/product is branded "Ello" (see README).

## Commands

```bash
flutter pub get                 # install dependencies
flutter run                     # run on a connected device/simulator
flutter analyze                 # static analysis (flutter_lints)
flutter test                    # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter build ios / apk         # release builds
```

Requires a `.env` file at the repo root (gitignored) with `API_KEY` (OpenAI), `PORCUPINE_ACCESS_KEY`, and `EL_API_KEY` (ElevenLabs) — loaded via `flutter_dotenv` in `main.dart` before `runApp`. Firebase is initialized from the generated `lib/firebase_options.dart` (FlutterFire project `elloai`); `firebase.json` maps platform config file outputs (`google-services.json`, `GoogleService-Info.plist`).

Note: `test/widget_test.dart` is still the unmodified Flutter counter-app template and does not exercise this app — it will fail if run since `MyApp` requires Firebase/dotenv to be initialized first.

## Architecture

### Bootstrap & routing
`lib/main.dart` loads `.env`, initializes Firebase, then wraps everything in a Riverpod `ProviderScope`. `AppRouter` watches `AuthUserProvider` (a `StreamProvider<AppUser?>`) and picks the root screen: `LoginScreen` (signed out) → `OnboardingFlow` (signed in, `onboardingCompleted == false`) → `NovaTodoAddTaskToday` (the current app home). State management throughout the app is **Riverpod** (`Provider`, `StreamProvider`, `Notifier`, `AsyncNotifier`) — there is no other state layer.

### Feature structure (`lib/features/`)
Each feature loosely follows domain/data/presentation layering:
- **auth/** — `domain/entities/app_user.dart` (`AppUser`), `domain/respository/{auth,user}/base_*_repository.dart` abstract contracts, `data/repositories/*` Firebase-backed implementations, `presentation/auth_provider/*` wires repositories into Riverpod providers, `presentation/controllers/auth_controller.dart` is an `AsyncNotifier` used by the screens for sign up/log in/reset password.
- **onboarding/** — first-run flow shown when `AppUser.onboardingCompleted` is false. `data/onboarding_local_service.dart` (`OnboardingLocalService`, exposed via `onboardingLocalServiceProvider`) is a device-local Hive flag for "has this device seen onboarding", separate from the Firestore-backed `AppUser.onboardingCompleted`; call `init()` once before use.
- **personas/** — the app's assistants. Each persona has its own domain/data/presentation split and a Firestore-backed repository:
  - **Nova** — task/productivity persona (todos, groceries, reminders, appointments, voice memos). Firestore path: `users/{userId}/personas/{personaId}/{todos|groceries|reminders|appointments}`.
  - **Zen** — journaling/mood persona (`data/models/journal_entry.dart`, `mood_model.dart`).
  - `sage/` and `spark/` exist as empty placeholder directories for future personas (theming for both already exists in `personaTheme_provider.dart`).
- **ello/** — the generic assistant home/tap-to-speak screen, separate from persona-specific screens.

### Persona theming
`lib/shared/providers/personaTheme_provider.dart` defines a `Notifier<PersonaTheme>` (`personaThemeProvider`) with hardcoded gradient/button colors and ElevenLabs `voiceId`/stability/similarity per persona name (`Nova`, `Zen`, `Spark`, `Sage`; defaults to Nova). `main.dart` reads this provider and rebuilds the `MaterialApp` theme inside an `AnimatedTheme` so switching personas animates the app's color scheme and app bar.

### Voice pipeline
- **Wake word**: `lib/shared/services/porcupine/porcupine_service.dart` wraps `PorcupineManager`, listening for the "Hey Nova" keyword file (`assets/resources/keyword_files/...`). `lib/shared/widgets/assistant_wake_word.dart` drives the full flow: wake word detected → `speech_to_text` starts listening → transcript is surfaced via `assistantProvider` (in `lib/providers/assistant_provider.dart`) → after a short delay, navigates to `PersonaPresets` with the transcribed text.
- **NLU**: `lib/core/NLU/models/*_slot_dto.dart` define structured "slot" DTOs (appointment, grocery, journal, reminder, voice reminder) that transcribed voice input is parsed into so personas can act on structured intents rather than raw text.
- **LLM/TTS**: `lib/shared/services/openAi/openAI_service.dart` calls the OpenAI chat completions API directly via `http` (including a manual SSE stream parser in `streamChatGPTAPI`). `lib/shared/services/ElevenLabsTTS/` and `lib/shared/services/speechSynthesis/` handle text-to-speech playback (via `just_audio`/`audioplayers`) and speech-to-text handoff. All of these are re-exported through the `lib/shared/services/services.dart` barrel file — import that instead of individual service files where practical.

### Shared layer (`lib/shared/`)
Cross-persona building blocks: `models/` (e.g. `task_item.dart`, `message_model.dart`, `personaTheme_model.dart`), `widgets/` (chat bubbles, persona cards, glass/gradient backgrounds, voice input fields), `screens/` (`chat_screen.dart`, `persona_presets.dart` — the persona picker shown after a voice capture). Feature code depends on `shared/`; `shared/` does not depend back on `features/`.
