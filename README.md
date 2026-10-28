# Japanese Interval Walking Timer

[日本語](README_ja.md)

An Android interval timer for Japanese-style interval walking: alternating slow
and brisk walking. It shows the state on screen and announces it by voice.

## Features

- Each lap has two halves: slow walking, then brisk walking. By default each half
  is 3 minutes and a run is 10 laps, then the timer stops.
- Voice guidance:
  - At the start of a lap: the lap number (twice), then "walk slowly".
  - At the start of the second half: "walk briskly".
  - A 3-2-1 countdown at the end of each half.
  - A closing message after the last lap.
- A circular progress indicator covers one whole lap (both halves). The icon in
  the circle changes between slow and brisk walking, with the lap count (`n/10`)
  under it.
- Start, Pause and Stop buttons. Stop asks for confirmation and then clears the
  state.
- The timer and the guidance continue in the background and with the screen
  locked, using a foreground service.
- While speaking, other apps' audio is lowered (ducked) and resumes afterwards.
- Japanese and English UI and voice. Japanese is used when the Android language
  is Japanese, English otherwise.
- The Android app name is localized as "インターバル速歩" in Japanese and
  "Japanese Walking" otherwise.

## Settings

Open them from the drawer (hamburger menu).

- Color scheme: follow the system (wallpaper colors) or a custom theme color.
- Color variation (custom only): Vivid, Tonal, Neutral, Monochrome.
- Number of laps (1-15) and the length of each half (10 s to 5 min). These
  cannot be changed while the timer is active.
- Voice volume.

## Requirements

- Flutter 3.32 / Dart 3.8
- Android 7.0 (API 24) or later

## Build and run

```sh
flutter pub get
flutter run                          # follows the OS language
flutter run --dart-define=LOCALE=en  # force English (or ja) for debugging
flutter build apk
```

## Test

```sh
flutter analyze
flutter test
```

## Notes

- Localized strings are in `lib/l10n/*.arb`; `flutter gen-l10n` regenerates the
  code.
- The Android `compileSdk`, NDK and `minSdk` are set in
  `android/app/build.gradle.kts` to meet the plugins' requirements.
- Foreground audio ducking and background behavior depend on the device and on
  the other app; verify them on a real device.
