//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    func swimlane() -> some View {
        modifier(SwimlaneModifier())
    }
}

private struct SwimlaneModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .scrollIndicators(.hidden)
            .scrollClipDisabled(true)
    }
}
