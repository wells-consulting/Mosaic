# Symbols and Labels

Name a symbol with Motley's `SFSymbol`, then lay it out with a Mosaic label.

## Name the symbol

`SFSymbol` is an enum, so a misspelled symbol is a compile error instead of a
blank image:

```swift
import Motley

Image(.chevron_right)
Label("Download", symbol: .arrow_down_circle)
Toggle("Repeat", symbol: .repeat, isOn: $repeats)
```

Mosaic adds those initializers to `Image`, `Label` and `Toggle`, so a view does
not need to spell `systemName:` anywhere. Add a case to Motley, not a string to
an app.

## SymbolLabel

``SymbolLabel`` pairs an icon with text and controls the two separately.

```swift
SymbolLabel(
    "Downloads",
    symbol: .arrow_down_circle,
    tint: .hierarchical(.secondary),
    details: "12 items",
    badge: "1.2 GB",
    addChevron: true,
)
```

The `layout` decides where the icon sits:

- `.column` gives the icon a fixed width, so labels stack with their text lined
  up. This is the default.
- `.inline` lets the icon take its own width, for a status line beside other
  text.

`details` is a second line under the title. `badge` is a short value after the
title. `addChevron` adds the trailing chevron for a row that opens something.

## Tint the layers

``SymbolTint`` comes with the mode it belongs to, so a tint cannot be handed the
wrong number of colors:

```swift
let oneColor = SymbolTint.monochrome(.secondary)
let dimmed = SymbolTint.hierarchical(.accentColor)
let twoLayers = SymbolTint.palette(.primary, .secondary)
let threeLayers = SymbolTint.palette(.red, .white, .blue)
let original = SymbolTint.multicolor
```

On tvOS a focused row turns its symbol black so it stays visible on the white
highlight.

## Icon buttons and menus

``SymbolButton`` is an icon-only button. The accessibility label is required, so
it cannot be left out:

```swift
SymbolButton(.gearshape, accessibilityLabel: "Settings") {
    openSettings()
}
```

``SymbolMenu`` is the same idea for a menu. `tint` colors the trigger when the
menu is in a non-default state:

```swift
SymbolMenu(.line_3_horizontal, label: "More", tint: isFiltered ? .accentColor : nil) {
    Button("Newest First") { sort(.newest) }
    Button("Oldest First") { sort(.oldest) }
}
```

Both controls let the containing layout draw their glass. Inside a
``ButtonGroup``, that means the group's pill is the only surface.

## Message and async labels

``MessageLabel`` takes a Motley `Message` and draws its kind symbol beside the
summary. `prefixTitle` puts the message's title first.

``AsyncLabel`` is the label for a button that starts work. It cross-fades
between its symbol and a spinner:

```swift
Button {
    Task { await refresh() }
} label: {
    AsyncLabel("Refresh", symbol: .arrow_counterclockwise, loading: isRefreshing)
}
```

## Where to go next

- <doc:cards-and-banners> uses these labels inside cards.
- <doc:buttons> covers the icon buttons in a group.
- ``SymbolLabel`` and ``SymbolTint`` are the two types to read next.
