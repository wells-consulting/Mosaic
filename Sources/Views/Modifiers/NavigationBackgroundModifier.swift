//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Sets the NavigationStack container background on iOS to the same
    /// radial vignette used on tvOS. Uses `EllipticalGradient` as a
    /// `ShapeStyle` so that `containerBackground` can automatically fill
    /// the entire navigation container — including behind the floating
    /// sidebarAdaptable TabView chrome on iPadOS. No-op on other platforms.
    func navigationBackground() -> some View {
        #if !os(tvOS)
            modifier(NavigationBackgroundModifier())
        #else
            self
        #endif
    }
}

#if !os(tvOS)
    /// Navigation container vignette that adapts to light and dark mode via the active `Palette`.
    private struct NavigationBackgroundModifier: ViewModifier {

        var placement: ContainerBackgroundPlacement {
            #if os(macOS)
                .window
            #else
                .navigation
            #endif
        }

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
#endif
