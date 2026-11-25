//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// How a scroll view's content changes, which decides whether the scroll
/// indicator helps.
public enum ScrollContentDisposition {

    /// Content that changes page by page.
    case paged

    /// Content that stays put, such as a settings page.
    case fixed
}

public extension View {

    /// Sets the scroll indicator for a scroll view.
    ///
    /// A vertical, fixed scroll view keeps the indicator on iOS. Everything
    /// else hides it.
    ///
    /// - Parameters:
    ///   - axis: The scroll axis.
    ///   - disposition: How the content changes.
    func mosaicScrollView(
        _ axis: Axis.Set,
        source disposition: ScrollContentDisposition
    ) -> some View {
        modifier(
            MosaicScrollIndicatorsModifer(
                axis: axis,
                disposition: disposition
            )
        )
    }
}

private struct MosaicScrollIndicatorsModifer: ViewModifier {

    let visibility: ScrollIndicatorVisibility

    init(axis: Axis.Set, disposition: ScrollContentDisposition) {
        #if os(iOS)
            self.visibility =
                if axis == .vertical, disposition == .fixed {
                    .automatic
                } else {
                    .hidden
                }
        #else
            self.visibility = .hidden
        #endif
    }

    func body(content: Content) -> some View {
        content
            .scrollIndicators(visibility)
    }
}
