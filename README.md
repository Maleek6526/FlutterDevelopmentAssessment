# Flutter Development Assessment

Cross-platform Flutter app (Android, iOS, Web, Windows, Linux) that displays a list of items and lets users add, edit, and delete them. Data and theme preference persist locally.

## Features
- Add, edit, and delete items
- Swipe to delete on the home list
- Clear theme toggle button in the app bar (Light/Dark)
- Persistent local storage for items and theme preference

## Tech Stack
- `flutter` stable SDK
- `flutter_riverpod` – state management
- `shared_preferences` – lightweight persistence

## Requirements
- Flutter SDK installed and on PATH
- Android: USB debugging enabled or a local emulator
- iOS: macOS with Xcode (for building/testing on iPhone)

## Getting Started
1) Install dependencies:
```
flutter pub get
```
2) Verify connected devices:
```
flutter devices
```
3) Run the app on a device/emulator:
```
flutter run -d <device-id>
```

## Build Android Release
Create a production APK for distribution:
```
flutter build apk --release
```
The APK will be generated at:
```
build\app\outputs\flutter-apk\app-release.apk
```

### Install APK on Android
- Copy `app-release.apk` to your device and open it, or install via ADB:
```
adb install -r build\app\outputs\flutter-apk\app-release.apk
```
- If blocked, enable “Install unknown apps” for your file manager/browser.

### Play Store Submission (Optional)
- Generate a signed `AAB` for Play Console:
```
flutter build appbundle --release
```
- Requires creating a keystore and setting signing configs in `android/app`.

## iOS Build (Mac Required)
- iOS builds require macOS and Xcode with an Apple Developer account.
- Typical flow: configure bundle ID, signing, `flutter build ipa`, then distribute via TestFlight.

## Project Structure
- `lib/models/item.dart` – Item model
- `lib/providers/items_provider.dart` – Items state (CRUD + persistence)
- `lib/providers/theme_provider.dart` – ThemeMode state (persisted)
- `lib/features/home` – Home screen and item tiles
- `lib/features/edit` – Add/Edit screen
- `lib/main.dart` – App entry, theme setup, routing

## Testing Checklist
- Launch app and verify the theme toggle button is visible
- Add a new item and confirm it appears on the list
- Edit an existing item and confirm changes persist
- Swipe to delete and confirm removal persists after restart
- Toggle Light/Dark, close the app, and confirm the choice persists

## Troubleshooting
- First build can take time; keep your Android device unlocked
- On Windows, enable Developer Mode for symlink support (`start ms-settings:developers`)
- If `adb` does not see your device, switch USB mode to File Transfer (MTP) and re-allow debugging
