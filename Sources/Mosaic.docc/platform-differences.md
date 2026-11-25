# Platform Differences

Mosaic builds for iOS 26, tvOS 26 and macOS 26. Most of the shared API is the
same everywhere. These are the places where a platform has its own answer.

## The scales

``Platform`` hides the numbers. tvOS gets more room because the screen is
watched from across the room. macOS follows the iOS values.

| Step | iOS and macOS | tvOS |
| --- | --- | --- |
| Spacing xsmall | 4 | 8 |
| Spacing small | 8 | 12 |
| Spacing medium | 12 | 20 |
| Spacing standard | 16 | 24 |
| Spacing large | 20 | 32 |
| Spacing xlarge | 32 | 48 |
| Padding xsmall | 4 | 8 |
| Padding small | 8 | 12 |
| Padding medium | 12 | 16 |
| Padding large | 16 | 24 |
| Padding xlarge | 24 | 36 |

Corner radius is the same on every platform: 8, 12, 16 or 20 points.

The type scale is semantic. `.body`, `.headline` and the other standard styles
use the system's own metrics. The named styles, such as `.note`, `.prose` and
`.settingsIntro`, pick a larger size on macOS because the system text styles
are smaller there.

## Settings

This is the biggest split:

- **iOS** uses `SettingsList` with `SettingsListToggleRow`,
  `SettingsListChoiceRow`, `SettingsListLinkRow` and `SettingsListActionRow`.
  The rows are system list rows, so a picker can live inside one.
- **tvOS and macOS** use ``SettingsPage`` with ``SettingsSection`` and
  ``SettingsRowButton``. A row is a focusable pill on tvOS and a row on macOS.

Use the same data on both. Only the page shape changes. See
<doc:settings-pages>.

## Controls that change shape

- `ButtonGroup` draws one glass pill on iOS. On tvOS it gets out of the way and
  the focus engine handles the controls.
- `.mosaicGlassButtonStyle()` and `.mosaicGlassMenuContent()` are iOS only. On
  the other platforms the system button styles already look right.
- `.mosaicScrollsToTop()` and `MosaicScrollToTopCoordinator` are iOS only.
- `.mosaicBackNavigation()` is tvOS only. It pops a navigation stack when the
  system bar is hidden and the person presses Menu.
- `PlatformGroupBox` falls back to a plain padded container on tvOS, where
  `GroupBox` does not exist.
- `PlatformDisclosureGroup` renders its label and content inline on tvOS, always
  expanded. The other platforms get a real disclosure group.
- `MosaicInertRowButtonStyle` is tvOS only. It gives a read-only row focus
  without the raised-pill look.
- `StandaloneGlassButtonStyle` is iOS only.

## The Mac

A Mac has services the other platforms do not:

- `DockIcon` shows or hides the Dock icon for a menu-bar-only mode.
- `FolderPicker` picks a folder.
- `MainAppLoginItem` and `LoginItemState` drive "Open at login".
  `LoginItemControlling` is the seam a test can use instead.
- `Clipboard` is available on macOS only. On iOS and tvOS the copy affordance is
  hidden.

The Mac also reports `hasPointer == true` in ``ContainerLayout``. Pointer-only
affordances stay on the Mac, because an iPad's trackpad cannot be seen from the
view.

## What to test

- Build the package for all three destinations.
- Run a settings page on iOS and on tvOS. The row shapes are different.
- Check a card focus effect on tvOS. It is the one interaction with no pointer
  fallback.
- Check the Mac services in a Mac build. They do not exist elsewhere, so a
  shared file cannot compile them by accident.

## Where to go next

- <doc:layout> covers `DeviceLayout` and `ContainerLayout`.
- <doc:settings-pages> covers the two settings shapes.
- <doc:modifiers-and-focus> covers the platform-only modifiers.
