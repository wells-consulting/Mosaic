//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Makes the view a focus section on tvOS. No-op elsewhere.
    func mosaicFocusSection() -> some View {
        #if os(tvOS)
            focusSection()
        #else
            self
        #endif
    }
}
