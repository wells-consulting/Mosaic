# Agent guide for Mosaic

Mosaic is a few pieces of SwiftUI: the controls, cards, palette and platform
fallbacks that keep an app looking like itself. Apps link it by version, so a
change isn't live until it's tagged.

Read [VOICE.md](VOICE.md) before you write a comment, a doc comment, a name, a
log message, UI text or a commit message. If this file and VOICE.md disagree,
VOICE.md wins. Text a control shows also follows the app that shows it.

`mosaic-change` in `.agents/skills/` is the procedure: building it, proving it,
and how to tag it. This file is the rules.

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
- iOS 26, tvOS 26, macOS 26.
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
- The public API is shared by more than one app, so a rename or a removed
  default is a breaking change in all of them. Add a default instead of changing
  one.

## Doc comments

The public API is also the documentation site, so a public doc comment is
reference material, not conversation. Add these on top of what VOICE.md says:

- Summary sentence first, then a discussion paragraph only if there is a
  gotcha: a fallback, a platform difference, a range.
- `- Parameter`, `- Returns` and `- Throws` on methods and initializers.
- One short example when the call is easier to show than to describe.
- Obvious constants and enum cases stay blank.

The guides live in `Sources/Mosaic.docc`. Read them before changing a control
they describe.

## Disclosure

`AI-DISCLOSURE.md` is the same file in every package I publish. If you change it, change it in all of them.

## Build and test

```sh
swift test
Scripts/format.sh       # swift format
Scripts/build-docs.sh         # builds the DocC guides for iOS and macOS
```

`.swift-format` is the formatting source of truth, and SwiftLint runs as a
build plugin, so a warning is a failure.
