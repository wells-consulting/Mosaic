# Getting Started

Add Mosaic to an app, install a palette, and draw the first card.

## Add the package

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

Mosaic brings Motley with it, so the app can import `SFSymbol` and `Message`
from the same checkout.

## Install a palette

Every control reads its colors from `PaletteStore`. The store starts on a
neutral placeholder, so a view renders before the app has made a choice. Set
the app's palette at launch:

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

`MyPalette` is a type in your app that conforms to ``Palette``. The
<doc:palette-and-color> guide shows a full conformance and the app-specific slots a
palette can add.

## Give the controls a layout

`.mosaicInjectDeviceLayoutEnvironment()` reads the device and the rendered
geometry once at the root and puts the result in `@Environment(\.layout)`. On
macOS and tvOS it does nothing, because the default is already right. Views
that need one container instead of the whole device use
`.mosaicMeasuresContainerLayout()`.

## Draw a card and a button

```swift
struct BatteryCard: View {
    var body: some View {
        CardPanel {
            VStack(alignment: .leading, spacing: Platform.spacing(.small)) {
                Text("Battery")
                    .mosaicFont(.headline)
                Text("82%")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(Platform.padding(.large))
    }
}

Button("Save") { save() }
    .mosaicButtonStyle(.confirm)
```

`CardPanel` draws the palette's card fill and border. `Platform.spacing` and
`Platform.padding` pick the values for the current platform, so the same view
reads correctly on a phone, a TV and a Mac.

## Where to go next

- <doc:palette-and-color> fills the shared color roles and adds app-specific tokens.
- <doc:layout> covers the device and container layouts and the adaptive grids.
- <doc:buttons> explains the button roles, prominence and density.
- <doc:settings-pages> builds a settings page for each platform.
- ``CardPanel`` and ``BannerView`` are the two containers most views start from.
