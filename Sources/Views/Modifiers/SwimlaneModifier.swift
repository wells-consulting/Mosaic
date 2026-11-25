//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Hides the scroll indicators and lets a card row draw past its scroll
    /// view's edge, so the tvOS focus scale is not clipped.
    func mosaicSwimlane() -> some View {
        modifier(MosaicSwimlaneModifier())
    }
}

private struct MosaicSwimlaneModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .scrollIndicators(.hidden)
            .scrollClipDisabled(true)
    }
}
