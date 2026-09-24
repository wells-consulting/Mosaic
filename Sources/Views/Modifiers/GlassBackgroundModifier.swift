//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {
    func mosaicGlassBackground(_ tint: Color, cornerRadius: CGFloat = 16) -> some View {
        modifier(MosaicGlassBackgroundModifer(tint: tint, cornerRadius: cornerRadius))
    }
}

private struct MosaicGlassBackgroundModifer: ViewModifier {

    let tint: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .mosaicPadding(.horizontal, .large)
            .mosaicPadding(.vertical, .small)
            .glassEffect(
                .regular.tint(tint.opacity(0.25)),
                in: .rect(cornerRadius: cornerRadius)
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
