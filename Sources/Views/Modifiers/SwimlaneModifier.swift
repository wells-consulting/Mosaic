//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

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
