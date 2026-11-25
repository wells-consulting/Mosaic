# Modifiers and Focus

The `mosaic*` modifiers by job, and the environment values a control reads.

## Padding and insets

- `.mosaicPadding(_:_:)` pads by a step in the shared scale, or by the value for
  a named context.
- `.mosaicContentInsetPadding()` puts page content at the platform's content
  inset. Put it on the content, not on a `TabView`.
- `.mosaicSettingsContentInsetPadding()` keeps a settings page in its column.
- `.mosaicModalContentInsetPadding()` adds the 60pt modal inset on tvOS.
- `.mosaicTouchTarget(_:verticalInset:)` grows a small control's tap area toward
  44pt without moving its neighbors. A pointer or the television keeps the
  drawn size.

## Focus

``TVOSFocusEffect`` chooses the tvOS focus look:

```swift
card
    .mosaicCardFocus(hasFocus: isFocused, tvOS: .spotlight)
```

- `.hover` uses the system's raised-card ring.
- `.spotlight` scales the card and adds the spotlight shadow, then disables the
  system hover effect.

On iOS the modifier always uses the spotlight. `.mosaicFocusSection()` makes a
view a focus section on tvOS. `.mosaicFocusPadding()` adds the room the focus
scale needs in a grid, and does nothing elsewhere.

The television has no pointer, so the focus engine needs a target. For a row
that only needs focus for scrolling and is not actionable, use the tvOS-only
`.mosaicInertRowButtonStyle()`. It draws a subtle border on focus instead of the
system's raised pill.

## Glass

- `.mosaicGlassBackground(_:cornerRadius:)` puts a view on a tinted glass panel.
- `.mosaicGlassButtonStyle()` gives a standalone iOS button its glass pill.
  Inside a ``ButtonGroup`` it renders borderless, because the group draws the
  pill.
- `.mosaicGlassMenuContent()` does the same for a `Menu`'s content. Use it on
  the content, not on the menu itself.

## Scrolling

- `.mosaicScrollView(_:source:)` sets the scroll indicator. A vertical, fixed
  scroll view keeps it on iOS; everything else hides it. Pass
  ``ScrollContentDisposition``.
- `.mosaicScrollsToTop()` watches the scroll-to-top coordinator. Fire the
  coordinator to scroll every watching view to the top. iOS only.
- `.mosaicSwimlane()` hides the indicators and lets a card row draw past its
  scroll view, so the focus scale is not clipped.

```swift
@Environment(\.scrollToTopCoordinator) private var scrollToTop

Button("Top") {
    scrollToTop?.fire()
}
```

## Selection

```swift
card
    .mosaicSelectionOverlay(isSelected: isSelected, isActive: isEditing)
```

The overlay dims the unselected cards and puts a checkmark on the selected one.
When `isActive` is false it does nothing. ``MosaicSelectionIndicator`` is the
indicator alone, for a view that manages the layout itself.

## Navigation and messages

- `.mosaicBackNavigation()` intercepts the Siri Remote Menu button when the
  navigation bar is hidden.
- `.mosaicDismissAction(_:subtitle:perform:)` gives a page a visible back
  button and, on tvOS, the Menu button too.
- `.mosaicMessageAlert(_:)` presents a Motley `Message` as an alert while the
  binding is not nil.

## Fields and changes

- `.mosaicFormRowBackground(_:interactive:)` gives a display row the pill that
  matches the rounded text field.
- `.mosaicURLField()`, `.mosaicUsernameField()` and
  `.mosaicServerNameField()` set the keyboard and capitalization for those
  entries.
- `.mosaicOnChangeDebounced(of:delay:perform:)` runs work after a value settles.
- `.mosaicApplyIf(_:apply:)` applies a modifier only when a condition holds, so
  a conditional modifier does not need a new type.

## Environment

Controls read these values:

- `\.layout` is the ``DeviceLayout`` injected at the root.
- `\.containerLayout` is the nearest measured ``ContainerLayout``.
- `\.imageContentMode` decides whether an image card fits or fills its cell.
- `\.scrollToTopCoordinator` fires the scroll-to-top signal on iOS.
- `\.insideButtonGroup` is true inside a ``ButtonGroup``'s pill.
- `\.insideSettingsColumn` is true inside a page that already insets its
  content.

## Where to go next

- <doc:layout> explains the two layout values.
- <doc:buttons> uses the glass and focus modifiers.
- <doc:text-fields-and-errors> covers the text field styles.
