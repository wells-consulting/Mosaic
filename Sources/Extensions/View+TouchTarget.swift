//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Grows a small control's tap area towards 44 pt on a touch screen without
    /// moving anything around it.
    ///
    /// The padding is taken back after the hit shape is set, so only the target
    /// grows. With a pointer or on the television the drawn size stays as it is.
    func mosaicTouchTarget(
        _ layout: ContainerLayout,
        verticalInset: CGFloat = 12,
    ) -> some View {
        let inset = layout.hasPointer || layout.isTelevision ? 0 : verticalInset

        return padding(.vertical, inset)
            .contentShape(Rectangle())
            .padding(.vertical, -inset)
    }
}
