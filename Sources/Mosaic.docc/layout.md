# Layout

Two values decide most layouts: what device this is, and how much room one
container has.

## The device

``DeviceLayout`` describes the device once. Inject it at the app root:

```swift
WindowGroup {
    ContentView()
        .mosaicInjectDeviceLayoutEnvironment()
}
```

Read it anywhere below:

```swift
@Environment(\.layout) private var layout

var body: some View {
    if layout.isWide {
        twoColumns
    } else {
        oneColumn
    }
}
```

The cases describe the rendered content area, not the physical orientation:
`phoneTall`, `phoneWide`, `padTall`, `padWide` and `padCompact`. The convenience
properties are usually enough:

- `isPhone` and `isPad`.
- `isTall`, `isWide`.
- `widthConstrained`: a tall phone or a narrow split view. Drop button labels
  and icons here.
- `heightConstrained`: a wide phone.

On macOS and tvOS the modifier does nothing. The environment falls back to
`.padWide`, which is the right choice for both.

## One container

``ContainerLayout`` measures one container. A sidebar and a full window get
different results, which is the point. Put it on a container root:

```swift
HStack {
    sidebar
    detail
}
.mosaicMeasuresContainerLayout()
```

Read it below with `@Environment(\.containerLayout)`. A view that installs the
modifier cannot read the result, so use ``ContainerLayoutReader``:

```swift
ContainerLayoutReader { layout in
    content
        .padding(layout.widthClass == .compact ? 8 : 20)
}
```

The width classes use two thresholds: `compact` below 500 points, `regular`
from 500, and `wide` from 900. `hasPointer` is true on the Mac. `isTelevision`
is true on tvOS. Before the first measurement, and in a preview with no
modifier, the value is `ContainerLayout.fallback`, 900 points wide.

## Grids

``AdaptiveColumnsGrid`` lays out equal-width columns from a minimum width:

```swift
AdaptiveColumnsGrid(minimumColumnWidth: 160) {
    ForEach(fields) { field in
        fieldView(field)
    }
}
```

Use it when the item count changes and every cell should be the same width. The
platform default is about 280 points on tvOS and 140 elsewhere.

For a row that wraps, use ``FlowLayout``:

```swift
FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
    ForEach(tags) { tag in
        TagView(tag)
    }
}
```

Mark an item with `.mosaicFlowFlexible()` when it should take the leftover
width, such as a title before a value.

``AdaptiveFlowLayout`` keeps items on one line and hides the least important
ones first:

```swift
AdaptiveFlowLayout {
    status
        .mosaicVisibilityPriority(2)
    detail
        .mosaicVisibilityPriority(1)
}
```

If hiding every collapsible item still does not fit, the rest wrap to another
row. `.mosaicMinimumUsefulWidth` hides an item that would be narrower than it
can use. Use this for a metadata strip, not for content the person needs.

## Where to go next

- <doc:palette-and-color> supplies the colors these layouts use.
- <doc:settings-pages> uses `ContainerLayout` to keep a page in its column.
- ``ContainerLayoutReader`` and ``AdaptiveColumnsGrid`` are the two types to
  read next.
