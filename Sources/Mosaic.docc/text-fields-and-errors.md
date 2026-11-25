# Text, Fields and Errors

Long text, form fields and the view that explains a failure.

## Long text

``ExpandableTextView`` clamps text to a height and adds "Show More" when it
does not fit:

```swift
ExpandableTextView(
    description,
    font: .body,
    navigationBackground: nil,
)
```

The expanded text opens in a full-screen ``ScrollableTextView`` on iOS and tvOS
and in a sheet on macOS. ``ScrollableTextView`` can also stand alone when the
whole view is long text.

## Form sections

``FormSection`` groups fields under a title with a pair of hairlines:

```swift
FormSection("Server") {
    TextField("Address", text: $address)
        .mosaicURLField()
        .mosaicRoundedTextFieldStyle()

    RevealableSecureField("Password", text: $password)
}
```

- `.mosaicURLField()` turns off autocorrection and picks the URL keyboard on
  iOS.
- `.mosaicUsernameField()` picks the username content type.
- `.mosaicServerNameField()` turns off autocorrection and capitalisation.
- `.mosaicNumberPad()` picks the number pad where there is a software keyboard.
- `.mosaicRoundedTextFieldStyle()` draws the pill on iOS and the rounded border
  on macOS. It does nothing on tvOS.

``RevealableSecureField`` is a secure field with a show/hide button. The
revealed state belongs to the field, so the caller keeps only the text binding.

## Errors

``ErrorView`` shows an icon, a title, a summary, optional details, optional
diagnostics and up to three actions:

```swift
enum LoadAction: String, Hashable {
    case retry = "Try Again"
    case dismiss = "Dismiss"
}

ErrorView(
    title: "Couldn’t load the library",
    summary: "The server didn’t respond.",
    actions: [.retry, .dismiss],
    onAction: { action in
        switch action {
        case .retry: load()
        case .dismiss: dismiss()
        }
    },
)
```

The action type is generic. Each case becomes a button whose label is its raw
value, which keeps the buttons easy to name and easy to test.

There are three ways to seed the text:

- From any error, with `ErrorDescriptionOptions` deciding how much to say. A
  Motley error's summary and details are used when it has them.
- From a Motley `Message`.
- From a title, a summary and optional details.

``ErrorDismissAction`` is the single-button type for the cases that only need
"OK":

```swift
ErrorView(
    title: "Saved",
    summary: "Your changes are on disk.",
    onButtonTapped: dismiss,
)
```

When the error has a raw diagnostic, such as a `URLError` chain, the view offers
"Technical Details". ``RawDiagnosticsSheet`` is the sheet behind it: selectable,
monospaced text. Present it yourself if a page has diagnostics outside an
error.

For a short message that should not take over the screen, use the
`.mosaicMessageAlert` modifier instead.

## Where to go next

- <doc:modifiers-and-focus> covers the message alert and the field modifiers.
- <doc:cards-and-banners> covers the banner for a message that stays on the
  page.
- ``ErrorView`` and ``ExpandableTextView`` are the two types to read next.
