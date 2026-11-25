//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Applies `apply` when `condition` is true, and returns the view
    /// unchanged otherwise.
    @ViewBuilder
    func mosaicApplyIf(_ condition: Bool, apply: (Self) -> some View) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
