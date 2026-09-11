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
    func vignetteBackground() -> some View {
        modifier(VignetteBackgroundModifier())
    }

    /// Sets container background to an `EllipticalGradient` as a
    /// `ShapeStyle` so that `containerBackground` can automatically fill
    /// the entire navigation container.
    func vignetteContainerBackground(
        for placement: ContainerBackgroundPlacement,
    ) -> some View {
        modifier(
            VignetteContainerBackgroundModifier(placement: placement)
        )
    }
}

/// Radial vignette that adapts to light and dark mode via asset catalog colors.
private struct VignetteBackgroundModifier: ViewModifier {

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo in
                let maxDim = max(geo.size.width, geo.size.height)
                RadialGradient(
                    colors: PaletteStore.shared.palette.vignette,
                    center: UnitPoint(x: 0.50, y: 0.45),
                    startRadius: 0.10 * maxDim,
                    endRadius: 0.75 * maxDim,
                )
            }
            .ignoresSafeArea(),
        )
    }
}

private struct VignetteContainerBackgroundModifier: ViewModifier {

    let placement: ContainerBackgroundPlacement

    func body(content: Content) -> some View {
        content.containerBackground(for: placement) {
            EllipticalGradient(
                colors: PaletteStore.shared.palette.vignette,
                center: UnitPoint(x: 0.50, y: 0.45),
                startRadiusFraction: 0.10,
                endRadiusFraction: 0.75,
            )
            .transaction { $0.animation = nil }
        }
    }
}
