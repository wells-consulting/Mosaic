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
