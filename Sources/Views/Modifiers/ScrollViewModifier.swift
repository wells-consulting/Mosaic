//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public enum ScrollContentDisposition {
    case paged
    case fixed
}

public extension View {

    func scrollView(
        _ axis: Axis.Set,
        source disposition: ScrollContentDisposition
    ) -> some View {
        modifier(
            ScrollIndicatorsModifer(
                axis: axis,
                disposition: disposition
            )
        )
    }
}

private struct ScrollIndicatorsModifer: ViewModifier {

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
