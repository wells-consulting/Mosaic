//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Puts the view on a glass panel tinted by `tint`.
    ///
    /// - Parameters:
    ///   - tint: The color behind the glass. It is faded before use.
    ///   - cornerRadius: The panel's corner radius. Defaults to 16 points.
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
