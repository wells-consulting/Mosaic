# Agent guide for Mosaic

Mosaic is the shared SwiftUI toolkit: the controls, cards, palette and platform
fallbacks that make the app and the app look like the same app. Both link it
by version, so one app compiling proves nothing about the other.

Read [VOICE.md](VOICE.md) before you write a comment, a doc comment, a name, a
log message, UI text or a commit message. If this file and VOICE.md disagree,
VOICE.md wins. Text a control shows also follows the app that shows it.

`mosaic-change` in `.agents/skills/` is the procedure: building both apps
against this checkout, and how to tag and re-pin it. This file is the rules.

## The package

- `Views/Controls` — buttons, cards, banners, progress, settings rows, fields.
- `Views/Styles` — button styles and appearances, progress and text field
  styles.
- `Views/Modifiers` — focus, glass, swimlane, scroll and navigation modifiers.
- `Views/Layout` — flow layout and the adaptive grids.
- `Views/Environment` — the values a control reads from its app.
- `Palette` — `ColorToken`, `Palette` and `PaletteStore`.
- `Models` — `ContainerLayout` and `DeviceLayout`.
- `Platform/macOS` — dock icon, folder picker, login item.
- `Extensions` — the `View+...`, `Color+...` and `SFSymbol+...` helpers.

## Requirements

- Swift 6.4 tools, Swift 6 language mode, strict concurrency.
- iOS 26, tvOS 26, macOS 26, matching the apps.
- Dependencies: Motley and `SwiftLintPlugins`, nothing else.

## Rules

- A symbol comes from Motley's `SFSymbol`. Never a `systemName:` string; add a
  case to Motley instead.
- No `try?`. Catch and log, or return `nil`.
- No global functions or variables. Scope them to an enum.
- SwiftUI first. UIKit and AppKit only where a platform has no SwiftUI
  equivalent, behind `#if os(...)`.
- A `#Preview` that uses a fixture sits inside `#if DEBUG`, or an archive fails
  while previews still compile.
- The public API is shared by two apps, so a rename or a removed default is a
  breaking change in both. Add a default instead of changing one.

## Build and test

```sh
swift test
Scripts/verify-apps.sh  # builds the app and the app against this checkout
```

`.swift-format` is the formatting source of truth, and SwiftLint runs as a
build plugin, so a warning is a failure.
