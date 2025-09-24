## Nexa Assist — Voice AI Assistant (Flutter)

Nexa Assist is a cross‑platform voice assistant built with Flutter. It uses on‑device Speech‑to‑Text to capture your voice, sends your prompt to OpenAI for either a Chat response or an AI Image, and reads textual replies aloud using Text‑to‑Speech.

The app demonstrates a clean, minimal UI, simple stateful screen management, and integration with:
- Speech recognition (`speech_to_text`)
- Text‑to‑speech (`flutter_tts`)
- OpenAI Chat Completions and Image Generation


### Features
- Voice input via microphone, powered by `speech_to_text`.
- Smart routing of prompts:
  - If your speech implies image generation, calls OpenAI Images (DALL·E).
  - Otherwise, calls OpenAI Chat for a text completion.
- Displays generated images inline.
- Speaks textual responses aloud with `flutter_tts`.
- Simple, responsive UI with a central mic/stop floating action button.


### Tech Stack
- Flutter (Material 3)
- Dart 3
- Packages: `speech_to_text`, `flutter_tts`, `http`, `cupertino_icons`


### App Structure
```
lib/
  main.dart                 # App entry; sets up MaterialApp and HomeScreen
  openai_service.dart       # OpenAI API calls (chat + images + prompt routing)
  secrets.dart              # Defines openAIAPIKey (local only; do not commit real keys)
  screens/
    home_screen.dart        # UI + voice capture + TTS + result rendering
  widgets/
    feature_card.dart       # Small UI card for feature highlights
assets/
  images/virtual_assistant_image.png
  sounds/ (listening, stop, cancel)
```


### Prerequisites
- Flutter SDK installed and set up
- iOS: Xcode; Android: Android Studio + device/emulator
- An OpenAI API key with access to Chat Completions and Images


### Setup
1) Install dependencies
```
flutter pub get
```

2) Configure assets (already declared in `pubspec.yaml`):
```
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/sounds/
```

3) Provide your OpenAI API key
- Create or edit `lib/secrets.dart` locally:
```dart
const String openAIAPIKey = "REPLACE_WITH_YOUR_OPENAI_API_KEY";
```
- Ensure you do not commit your real key. Consider adding this file to your global git ignore or use environment‑specific workflows. The current code imports `openAIAPIKey` directly from this file.

4) Platform permissions (already configured)
- Android: `android/app/src/main/AndroidManifest.xml` includes `RECORD_AUDIO`, `INTERNET`, and speech query intents.
- iOS: `ios/Runner/Info.plist` includes `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription`.


### Run
- Android:
```
flutter run -d android
```
- iOS (device/simulator):
```
flutter run -d ios
```
- macOS / Windows / Linux (where supported):
```
flutter run -d macos   # or windows / linux
```


### Usage
1) Tap the mic button to start listening.
2) Speak your prompt.
   - Say something like: “Generate an image of a sunset over mountains” → app shows AI image.
   - Say something like: “What is the capital of Japan?” → app returns text and reads it aloud.
3) Tap the stop button to stop listening.


### Model and API Notes
- The code references OpenAI Chat (`gpt-3.5-turbo*`) and Images (DALL·E). If model names or endpoints change, update `lib/openai_service.dart` accordingly.
- Network calls use the `http` package; replace with your preferred client if needed.


### Troubleshooting
- Android mic permission denied: ensure you granted mic access in system settings.
- iOS simulator lacks a real microphone: prefer a physical device for voice features.
- No speech results: verify the device supports `SpeechToText.initialize()` and language.
- OpenAI errors: confirm billing/quota and that your key is valid and not rate‑limited.
- TTS not speaking: check device volume and `FlutterTts` initialization.

