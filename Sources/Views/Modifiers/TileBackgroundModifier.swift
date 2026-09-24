//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Applies a subtle filled tile background — use for stat cards, info tiles, and similar.
    func mosaicTileBackground(
        cornerRadius: CGFloat = 12
    ) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.primary.opacity(0.06))
        )
    }
}
