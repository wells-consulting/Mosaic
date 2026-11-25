# Settings Pages

A settings page has two shapes. iOS uses a list of system rows. tvOS and macOS
use a page of sections and focusable rows. Mosaic gives each shape its own
types.

## Pick a shape

Choose at the page, where the app already knows its platform:

```swift
#if os(iOS)
    SettingsList {
        Section("Playback") {
            SettingsListToggleRow("Include Previews", isOn: $includePreviews)
        }
    }
#else
    SettingsPage {
        SettingsSection("Playback") {
            SettingsRowButton("Include Previews", value: .fixed(includePreviews ? "On" : "Off")) {
                includePreviews.toggle()
            }
        }
    }
#endif
```

## The iOS list

`SettingsList` is an inset-grouped `List`. Its rows are normal iOS settings
rows: a `Toggle`, a segmented picker, a `NavigationLink` or an action.

```swift
SettingsList {
    Section("Playback") {
        SettingsListToggleRow("Include Previews", isOn: $includePreviews)
        SettingsListChoiceRow("Quality", options: Quality.allCases, selection: $quality) { $0.title }
        SettingsListLinkRow("Servers", value: .servers, detail: serverSummary)
        SettingsListActionRow("Clear Cache", detail: cacheSize) { clearCache() }
    }
}
```

- `SettingsListToggleRow` puts a note under the title when the switch cannot
  move yet.
- `SettingsListChoiceRow` puts the choices on a segmented control under the
  title. Keep each label to a word or two.
- `SettingsListLinkRow` pushes a value the host registers as a navigation
  destination.
- `SettingsListActionRow` runs an action without leaving the page. Use
  `.prominent` for the one action the page exists to run.

Every row has a `verbatim:` form for a name that is not a localization key,
such as a server type or a product.

## The tvOS and macOS page

``SettingsPage`` is a vertical scroll view of sections. ``SettingsSection``
gives each group a label and the page's spacing. ``SettingsRowButton`` is the
row.

```swift
SettingsPage {
    SettingsSection("Playback") {
        SettingsRowButton(
            "Include Previews",
            symbol: .eye,
            synopsis: "Show a frame from the next scene.",
            value: .fixed(includePreviews ? "On" : "Off"),
        ) {
            includePreviews.toggle()
        }

        SettingsRowButton(
            "Quality",
            value: .adjustable(full: quality.longTitle, abbreviated: quality.shortTitle),
            chevron: true,
        ) {
            chooseQuality()
        }
    }
}
```

``SettingsRowButton`` has room for an icon, a synopsis, a badge, a value and a
status. `Status.warning` paints the value in the warning color. `Density.compact`
drops the minimum height and insets the label, for a flat list of rows.

On a narrow screen the icon is dropped before the title is squeezed. Pass
`keepsSymbol: true` only when the icon carries meaning of its own.

## Cards and tables

Some settings content is not a row:

- ``SettingsCard`` wraps anything in the card surface. Pass `interactive: true`
  when the card is tappable, so it gets the glass fill on iOS.
- ``SettingsToggleBar`` is a whole card that switches on and off, with a
  checkmark at the trailing edge.
- ``SettingsTableBuilder`` builds a small table of labels and values inside a
  card.
- ``SettingsIntroText`` is the paragraph at the top of a page.
- ``SettingsMenu`` stacks rows with the menu gap.

```swift
let table = SettingsTableBuilder()
table.addRow("Version", "1.11.0")
table.addRow("Build", "1204", symbol: .hammer)

SettingsCard {
    table.build()
}
```

## Keep the page in its column

On iOS, `SettingsList` and ``SettingsPage`` already keep their content in the
settings column. A custom page can use `.mosaicSettingsContentInsetPadding()`.
On macOS it adds a small horizontal inset, and on tvOS it does nothing.

## Where to go next

- <doc:layout> explains the device and container values these pages read.
- <doc:buttons> covers the semantic roles used by the action rows.
- ``SettingsRowButton`` and ``SettingsPage`` are the two types to read next.
