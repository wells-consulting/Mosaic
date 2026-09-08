//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Paints a platform-appropriate background behind the view,
    /// extending into the safe area.
    ///
    /// - **tvOS / iOS**: A subtle radial vignette gradient with a
    ///   purple-tinted center that fades outward. Adapts to light/dark mode.
    /// Reference: `Documents/Platform-View-Modifiers.md` for ordering rules and per-view usage.
    func vignetteBackground(_ colors: [Color]) -> some View {
        modifier(VignetteBackgroundModifier(colors: colors))
    }
}

/// Radial vignette that adapts to light and dark mode via asset catalog colors.
private struct VignetteBackgroundModifier: ViewModifier {

    let colors: [Color]

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo in
                let maxDim = max(geo.size.width, geo.size.height)
                RadialGradient(
                    colors: colors,
                    center: UnitPoint(x: 0.50, y: 0.45),
                    startRadius: 0.10 * maxDim,
                    endRadius: 0.75 * maxDim,
                )
            }
            .ignoresSafeArea(),
        )
    }
}
