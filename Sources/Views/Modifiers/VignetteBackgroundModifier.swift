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
    /// - **macOS**: Routed through `.containerBackground(for: .window)`
    ///   rather than a plain `.background()`. The title bar area is drawn by
    ///   AppKit and isn't part of the content view's safe-area-extendable
    ///   frame, so a regular background can never paint underneath it — the
    ///   `.window` placement is the API that actually reaches that region,
    ///   which is what makes the vignette visible behind the whole window
    ///   (including sheets) instead of stopping at a flat, opaque edge.
    /// Reference: `Documents/Platform-View-Modifiers.md` for ordering rules and per-view usage.
    func vignetteBackground() -> some View {
        #if os(macOS)
            vignetteContainerBackground(for: .window)
        #else
            modifier(VignetteBackgroundModifier())
        #endif
    }

    func vignetteNavigationBackground() -> some View {
        #if os(iOS)
            vignetteContainerBackground(for: .navigation)
        #elseif os(macOS)
            vignetteContainerBackground(for: .window)
        #else
            self
        #endif
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
