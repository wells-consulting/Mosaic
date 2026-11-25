# Cards and Banners

The shared surfaces: a card, a group, a banner and the small pieces that sit
inside them.

## Cards

``CardPanel`` is the plain card. It reads the palette's `cardFill` and
`cardBorder` and takes a padding step:

```swift
CardPanel {
    VStack(alignment: .leading, spacing: Platform.spacing(.small)) {
        Text("Battery")
            .mosaicFont(.headline)
        Text("82%")
            .foregroundStyle(.secondary)
    }
}
```

Use `.warning` emphasis when the figure inside has a problem. The border turns
the warning color and gets wider; the content does not change.

``SettingsCard`` is the settings variant. It uses the platform's corner radius
and padding, and takes `interactive: true` when the card is tappable. See
<doc:settings-pages> for the settings family.

## Groups

``PlatformGroupBox`` is a titled group box with the television fallback and the
macOS focus halo already handled. Put it in a list row.

``PlatformDisclosureGroup`` is a `DisclosureGroup` that compiles on tvOS, where
the system type does not exist. On tvOS it renders the label and content
inline, always expanded. On the other platforms it behaves like the system
control. Pass a binding when the page owns the expanded state.

## Dividers

``ProminentDivider`` is the standard divider with a stronger color. Use it to
separate larger regions. ``SubtleDivider`` drops the system divider to 15%
opacity. Use it between rows inside a card.

## Banners

``BannerView`` is a tinted glass banner with an icon, a title, a subtitle and
optional trailing content:

```swift
BannerView(
    tint: .orange,
    title: "Storage nearly full",
    subtitle: "Free up space before the next recording.",
    leadingSymbol: .exclamationmark_triangle,
) {
    Button("Manage") { openStorage() }
        .mosaicButtonStyle(.neutral(.regular), density: .compact)
}
```

The three factories cover the usual cases and leave the trailing content
empty:

```swift
BannerView.success(title: "Saved", message: "Your changes are on disk.")
BannerView.warning(title: "Low battery", message: "Two hours remain.")
BannerView.error(title: "Upload failed", message: "Check the connection.")
```

Use `BannerView` for a message that stays on the page. For a message that
should interrupt, use `.mosaicMessageAlert` instead.

## Small pieces

- ``MetadataPill`` is a capsule with an icon and a short value, for resolution,
  codec, frame rate or file size.
- ``ProgressBar`` fills from `0` to `1`. It keeps a 25pt minimum fill so a
  barely-started bar is still visible.
- ``WarningMark`` is the small warning symbol with an explanation. Pass a
  `prefix` when the sentence needs a lead-in.
- ``Chevron`` is the trailing chevron for a row that opens something.

## Where to go next

- <doc:settings-pages> covers the settings cards and rows.
- <doc:buttons> covers the controls inside a banner.
- ``CardPanel`` and ``BannerView`` are the two types to read next.
