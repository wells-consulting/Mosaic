# Palette

Every color in Mosaic comes from one palette. Fill it once, install it, and the
controls follow.

## The roles

``Palette`` groups its roles by job:

- **Surfaces**: `cardFill`, `cardBorder` and `rowBackground`.
- **Neutral buttons**: a top and bottom for the regular and prominent tiers,
  plus `neutralLabel`.
- **Tints**: `accentTint`, `errorTint`, `warningTint` and `successTint` fill
  controls and indicators.
- **Labels**: `accentLabel`, `errorLabel` and `warningLabel` color symbols and
  text.
- **Gradients**: `vignette` paints the background, and `progress` fills a
  progress bar.
- **App colors**: `app` holds slots the app defines. It is empty by default.

Every role built from a changing light and dark value uses `Color(light:dark:)`.
The color resolves against the view's environment, so the same palette works in
both appearances.

## Make a palette

```swift
import Mosaic
import SwiftUI

struct Daylight: Palette {
    let id = "example.daylight"
    let name = "Daylight"

    let cardFill = Color(light: .white, dark: Color(white: 0.12))
    let cardBorder = Color(light: .black.opacity(0.12), dark: .white.opacity(0.18))
    let rowBackground = Color(light: .black.opacity(0.04), dark: .white.opacity(0.06))

    let neutralRegularTop = Color(light: .white, dark: Color(white: 0.18))
    let neutralRegularBottom = Color(light: Color(white: 0.92), dark: Color(white: 0.13))
    let neutralProminentTop = Color(light: Color(white: 0.45), dark: Color(white: 0.36))
    let neutralProminentBottom = Color(light: Color(white: 0.30), dark: Color(white: 0.24))
    let neutralLabel = Color(light: .white, dark: .white)

    let accentTint = Color(red: 0.20, green: 0.55, blue: 0.90)
    let errorTint = Color(red: 0.80, green: 0.25, blue: 0.25)
    let warningTint = Color(red: 0.90, green: 0.55, blue: 0.20)
    let successTint = Color(red: 0.25, green: 0.70, blue: 0.40)

    let accentLabel = Color(red: 0.20, green: 0.55, blue: 0.90)
    let errorLabel = Color(
        light: Color(red: 0.75, green: 0.20, blue: 0.20),
        dark: Color(red: 0.95, green: 0.45, blue: 0.45)
    )
    let warningLabel = Color(
        light: Color(red: 0.80, green: 0.45, blue: 0.10),
        dark: Color(red: 0.95, green: 0.70, blue: 0.40)
    )

    let vignette = [Color.black.opacity(0.08), .clear]
    let progress = [Color(red: 0.20, green: 0.55, blue: 0.90), .blue]
}
```

``Palette/tabBarTint`` and ``Palette/app`` have defaults, so a scheme can leave
them out.

## Install it

```swift
PaletteStore.shared.current = Daylight()
```

``PaletteStore`` is a single shared store on the main actor. Views read
`PaletteStore.shared.current` while they build their body, so a new palette
redraws every view that read a token. There is no environment injection.

Before the app installs a palette, the store holds a neutral placeholder. A
first-frame view still draws. If the app has a stored preference and a default,
use the default only when the app has not chosen yet:

```swift
PaletteStore.shared.setDefaultIfUnset(Daylight())
```

## Add app colors

The shared roles cover chrome. An app with extra meanings, such as a battery
level or a genre, adds tokens without changing the protocol:

```swift
extension ColorToken {
    static let battery = ColorToken("one.battery")
}

extension Daylight {
    var app: [ColorToken: Color] {
        [.battery: successTint]
    }
}
```

Read a token with a fallback, so a palette written before the token existed
still draws:

```swift
extension Palette {
    var batteryTint: Color {
        color(.battery) ?? successTint
    }
}
```

Give each app a different prefix. `"one.*"` and `"two.*"` keep two apps that
share Mosaic from colliding.

## Where to go next

- <doc:layout> uses the palette through the shared spacing and type scales.
- <doc:buttons> shows how the roles pick a fill and a label color.
- ``PaletteStore`` and ``ColorToken`` are the two types to read next.
