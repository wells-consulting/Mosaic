//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

private enum AdaptiveColumnsGridDefaults {

    /// Platform-conditional minimum column width applied when a caller does
    /// not supply one. tvOS sheets are wider so a larger minimum yields
    /// roughly 4 columns on typical detail surfaces; iPad / iPhone need a
    /// narrower minimum so the grid reflows gracefully on compact widths
    /// instead of collapsing to a single column.
    static let minimumColumnWidth: CGFloat = {
        #if os(tvOS)
            280
        #else
            140
        #endif
    }()
}

/// A grid that arranges its content in equal-width columns and wraps to new
/// rows automatically. The number of columns is determined by the container's
/// available width divided by `minimumColumnWidth` — wider containers get
/// more columns, and every column in a given layout is the same width.
///
/// Useful when the visible item count is dynamic (e.g. conditional fields
/// that change with feature flags or content mode) and a fixed column count
/// would leave awkward gaps or wasted space.
///
/// Built on `LazyVGrid` with a single `GridItem(.adaptive(minimum:))`. Prefer
/// this over a hand-rolled `LazyVGrid(columns:)` when:
/// - All columns should be the same width.
/// - The number of items is variable.
/// - You'd rather specify a minimum cell width than a fixed column count.
///
/// `minimumColumnWidth` is optional. When omitted, the grid uses a
/// platform-tuned default (~280pt on tvOS, ~140pt on iOS / iPadOS) so
/// call sites don't need to encode platform knowledge themselves. Override
/// only when a specific surface has different content-width requirements.
///
/// ```swift
/// AdaptiveColumnsGrid {
///     if let name { metadataField("Name", value: name) }
///     if let age { metadataField("Age", value: age) }
///     if let height { metadataField("Height", value: height) }
/// }
/// ```
public struct AdaptiveColumnsGrid<Content: View>: View {

    // MARK: - Fields

    let minimumColumnWidth: CGFloat
    let spacing: CGFloat
    let content: () -> Content

    // MARK: - Initializer

    public init(
        minimumColumnWidth: CGFloat? = nil,
        spacing: CGFloat = Platform.spacing(.small),
        @ViewBuilder content: @escaping () -> Content,
    ) {
        self.minimumColumnWidth =
            minimumColumnWidth
            ?? AdaptiveColumnsGridDefaults.minimumColumnWidth
        self.spacing = spacing
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: minimumColumnWidth),
                    spacing: spacing,
                    alignment: .leading,
                )
            ],
            alignment: .leading,
            spacing: spacing,
            content: content,
        )
    }
}
