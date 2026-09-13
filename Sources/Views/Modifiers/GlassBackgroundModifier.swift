//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {
    func glassBackground(_ tint: Color, cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassBackgroundModifer(tint: tint, cornerRadius: cornerRadius))
    }
}

private struct GlassBackgroundModifer: ViewModifier {

    let tint: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, .large)
            .padding(.vertical, .small)
            .glassEffect(
                .regular.tint(tint.opacity(0.25)),
                in: .rect(cornerRadius: cornerRadius)
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
