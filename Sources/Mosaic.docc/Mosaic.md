# ``Mosaic``

A few pieces of SwiftUI I got tired of rewriting: the controls, cards, palette
and platform fallbacks that keep an app looking like itself.

## Overview

`PaletteStore` holds the app's colors. `Palette` lists the roles a scheme
fills, and `ColorToken` adds app-specific slots without touching the shared
protocol. Every control reads the active palette, so changing it redraws the
views that read a token.

`DeviceLayout` describes the device once at the app root. `ContainerLayout`
measures one container, for views that need the room they actually have.
`AdaptiveColumnsGrid` and the flow layouts use those values.

The platform differences are built in. A control picks its spacing, type and
corner radius from `Platform`. The tvOS focus and macOS helpers live behind
`#if os(...)`, so the shared code stays readable.

The package builds for iOS 26, tvOS 26 and macOS 26. It depends on Motley for
`SFSymbol`, `Message` and the small shared helpers.

## Topics

### Guides

- <doc:getting-started>
- <doc:palette-and-color>
- <doc:layout>
- <doc:settings-pages>
- <doc:buttons>
- <doc:symbols-and-labels>
- <doc:cards-and-banners>
- <doc:text-fields-and-errors>
- <doc:modifiers-and-focus>
- <doc:platform-differences>

### Essentials

- ``Palette``
- ``PaletteStore``
- ``ColorToken``
- ``Platform``
- ``MosaicInfo``

### Environment and layout

- ``DeviceLayout``
- ``ContainerLayout``
- ``ContainerLayout/WidthClass``
- ``ContainerLayout/HeightClass``
- ``AdaptiveColumnsGrid``
- ``AdaptiveFlowLayout``
- ``FlowLayout``
- ``ContainerLayoutReader``

### Buttons

- ``ButtonAppearance``
- ``ButtonAppearance/Prominence``
- ``ButtonDensity``
- ``ButtonGroup``
- ``OverlayButton``
- ``MosaicProminenceButtonStyle``
- ``MosaicGridButtonStyle``

### Cards and surfaces

- ``CardPanel``
- ``CardPanel/Emphasis``
- ``PlatformGroupBox``
- ``PlatformDisclosureGroup``
- ``ProminentDivider``
- ``SubtleDivider``
- ``MetadataPill``
- ``ProgressBar``
- ``WarningMark``
- ``Chevron``

### Settings

- ``SettingsPage``
- ``SettingsSection``
- ``SettingsSectionLabel``
- ``SettingsRowButton``
- ``SettingsRowButton/Status``
- ``SettingsRowButton/Density``
- ``SettingsRowButton/AdaptiveText``
- ``SettingsMenu``
- ``SettingsToggleBar``
- ``SettingsCard``
- ``SettingsIntroText``
- ``SettingsTableBuilder``
- ``SettingsTableBuilder/TableRow``

### Symbols and labels

- ``SymbolLabel``
- ``SymbolLabel/Layout``
- ``SymbolTint``
- ``SymbolButton``
- ``SymbolMenu``
- ``MutedSymbolLabel``
- ``MessageLabel``
- ``AsyncLabel``

### Text and fields

- ``ExpandableTextView``
- ``ScrollableTextView``
- ``FormSection``
- ``RevealableSecureField``
- ``MosaicRoundedTextFieldStyle``

### Errors

- ``ErrorView``
- ``ErrorDismissAction``
- ``RawDiagnosticsSheet``

### Styles and modifiers

- ``TVOSFocusEffect``
- ``ScrollContentDisposition``
- ``MosaicCardFocusModifier``
- ``MosaicDebouncedChangeModifier``
- ``MosaicSelectionIndicator``
- ``MosaicGradientProgressViewStyle``
