# Buttons

Pick a job, not a color. The button style turns the job into a fill for the
current platform.

## The role

```swift
Button("Save") { save() }
    .mosaicButtonStyle(.confirm)

Button("Cancel") { cancel() }
    .mosaicButtonStyle(.cancel)
```

``ButtonAppearance`` has six cases:

- `.neutral(.regular)` is the ordinary button.
- `.neutral(.prominent)` is a neutral button with more weight.
- `.confirm` is the action that finishes the job.
- `.cancel` is a way out, in the warning color.
- `.close` dismisses something, in the regular neutral fill.
- `.destructive` deletes or discards.
- `.tinted(color)` fills the button with a color you choose.

A SwiftUI `.destructive` role wins over the appearance, so a button with
`role: .destructive` stays destructive.

## The density

``ButtonDensity`` has two tiers:

- `.large` is the roomy media-player look, with a 44pt touch floor on iOS and a
  66pt floor on tvOS.
- `.compact` is the ordinary app chrome tier, with shorter floors and a flat
  fill.

```swift
Button("Retry") { retry() }
    .mosaicButtonStyle(.neutral(.regular), density: .compact)
```

The default is `.large`, so existing call sites keep their look.

## The style itself

`mosaicButtonStyle` is the usual way in. Use ``MosaicProminenceButtonStyle``
directly only when a custom control needs the style:

```swift
Button("Play") { play() }
    .buttonStyle(.mosaic(.confirm))
```

``MosaicGridButtonStyle`` is the borderless style for a grid cell. It draws no
background or padding, so the cell content supplies the shape.

## A group of controls

``ButtonGroup`` puts a small cluster of controls inside one glass pill:

```swift
ButtonGroup {
    SymbolButton(.shuffle, accessibilityLabel: "Shuffle") { shuffle() }
    SymbolButton(.arrow_counterclockwise, accessibilityLabel: "Reload") { reload() }
}
```

The children opt out of their own glass automatically, so only the parent's pill
is visible. `spacing` takes `.standard` or `.none`. The group is iOS only; tvOS
uses the system focus treatment.

## Overlay buttons

``OverlayButton`` is the icon-over-label button used in player overlays and
detail action bars. On tvOS it takes a focus fill, a scale spring and a border.
On iOS the system press highlight is enough.

```swift
OverlayButton(symbol: .play_fill, label: "Play") {
    play()
}
```

## Where to go next

- <doc:palette-and-color> supplies the fills and label colors.
- <doc:symbols-and-labels> covers the icon buttons used in a group.
- ``ButtonAppearance`` and ``ButtonDensity`` are the two types to read next.
