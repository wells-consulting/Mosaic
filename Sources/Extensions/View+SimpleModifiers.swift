//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Selectable text. The television has no pointer to drag a selection with,
    /// and the modifier isn't there.
    func mosaicEnableTextSelection() -> some View {
        #if os(macOS) || os(iOS)
            textSelection(.enabled)
        #else
            self
        #endif
    }
}
