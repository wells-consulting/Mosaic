# Mosaic

A few pieces of SwiftUI I got tired of rewriting: the controls, cards, palette
and platform fallbacks that keep an app looking like itself.

The package builds for iOS 26, tvOS 26 and macOS 26. It has one dependency,
[Motley](https://github.com/wells-consulting/Motley), for the symbol names and
the small shared helpers.

## Install

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/wells-consulting/Mosaic.git", from: "1.11.0"),
]
```

Then add the product to the target that needs it:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "Mosaic", package: "Mosaic")
    ]
)
```

## Usage

Install a palette at launch and inject the device layout once:

```swift
import Mosaic

@main
struct MyApp: App {
    init() {
        PaletteStore.shared.current = MyPalette()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .mosaicInjectDeviceLayoutEnvironment()
        }
    }
}
```

Draw a card and a button:

```swift
CardPanel {
    VStack(alignment: .leading, spacing: Platform.spacing(.small)) {
        Text("Battery")
            .mosaicFont(.headline)
        Text("82%")
            .foregroundStyle(.secondary)
    }
}
.padding(Platform.padding(.large))

Button("Save") { save() }
    .mosaicButtonStyle(.confirm)
```

`MyPalette` is a type in your app that conforms to `Palette`. The neutral
placeholder keeps the first frame drawing before it is installed.

## What's inside

- **Controls**: cards, banners, dividers, progress, pills, warnings, text
  fields, long text and the error view.
- **Settings**: a list shape for iOS and a page shape for tvOS and macOS, with
  rows, toggles, choices, links, actions and tables.
- **Palette**: the shared color roles, the store and app-specific tokens.
- **Layout**: the device and container measurements, the adaptive grid and the
  flow layouts.
- **Symbols**: labels, buttons and menus built on Motley's `SFSymbol`.
- **Platform**: the spacing, padding, type and corner scales, plus the macOS
  dock, folder and login-item helpers.

## Documentation

The DocC guides ship with the package. Open the package in Xcode and choose
**Product > Build Documentation** to read them.

- [Getting Started](Sources/Mosaic.docc/getting-started.md)
- [Palette](Sources/Mosaic.docc/palette-and-color.md)
- [Layout](Sources/Mosaic.docc/layout.md)
- [Settings Pages](Sources/Mosaic.docc/settings-pages.md)
- [Buttons](Sources/Mosaic.docc/buttons.md)
- [Symbols and Labels](Sources/Mosaic.docc/symbols-and-labels.md)
- [Cards and Banners](Sources/Mosaic.docc/cards-and-banners.md)
- [Text, Fields and Errors](Sources/Mosaic.docc/text-fields-and-errors.md)
- [Modifiers and Focus](Sources/Mosaic.docc/modifiers-and-focus.md)
- [Platform Differences](Sources/Mosaic.docc/platform-differences.md)

## Testing

```sh
swift test
Scripts/build-docs.sh       # builds the DocC guides for iOS and macOS
```

## License

MIT. See [LICENSE](LICENSE).
