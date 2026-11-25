//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

extension View {

    /// Applies a pill-shaped capsule background to a display row,
    /// matching the shape, height, and fill of `.mosaicRoundedTextFieldStyle()`.
    /// No-op on tvOS.
    public func mosaicFormRowBackground(
        _ neutralColor: Color,
        interactive: Bool,
        nonInteractiveColor: Color = .init(
            light: Color.primary.opacity(0.05),
            dark: Color.white.opacity(0.10)
        )
    ) -> some View {
        #if os(iOS)
            modifier(
                MosaicFormRowBackgroundModifier(
                    neutralColor: neutralColor,
                    interactive: interactive,
                    nonInteractiveColor: nonInteractiveColor
                )
            )
        #else
            self
        #endif
    }
}

#if os(iOS)
    @MainActor
    private struct MosaicFormRowBackgroundModifier: ViewModifier {

        @Environment(\.layout) private var layout

        let neutralColor: Color
        let interactive: Bool
        let nonInteractiveColor: Color

        private var fillColor: Color {
            interactive ? neutralColor : nonInteractiveColor
        }

        func body(content: Content) -> some View {
            content
                .padding(.horizontal, layout.widthConstrained ? 16 : 24)
                .frame(minHeight: 44)
                .background(Capsule().fill(fillColor))
        }
    }
#endif
