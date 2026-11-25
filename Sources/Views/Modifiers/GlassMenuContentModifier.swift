//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Applies `.glassEffect(.clear.interactive())` on iOS for `Menu` views.
    /// Use this instead of `mosaicGlassButtonStyle()` on `Menu`s, because
    /// `.buttonStyle(.glass(.clear))` crashes at runtime when cascaded to a
    /// `Menu`'s internal trigger button. Use this on the `content`, not the
    /// menu itself. Otherwise the content tap area does not receive the
    /// correct padding and tap-area adjustments.
    func mosaicGlassMenuContent() -> some View {
        #if os(iOS)
            modifier(MosaicGlassMenuStyleModifier())
        #else
            self
        #endif
    }
}

#if os(iOS)
    private struct MosaicGlassMenuStyleModifier: ViewModifier {

        @Environment(\.insideButtonGroup) private var insideButtonGroup

        func body(content: Content) -> some View {
            if insideButtonGroup {
                // Parent `GlassButtonGroup` provides the shared pill — render the menu
                // label inline without its own glass surface or extra padding.
                content
            } else {
                // Standalone menu: same chrome dimensions as `GlassButtonGroup` AND
                // `mosaicGlassButtonStyle()`'s `.glass(...).controlSize(.large)` button so all
                // three converge on ~44pt height with the same tint.
                content
                    .padding(.vertical, 16)
                    .padding(.horizontal)
                    .frame(minHeight: 22)
                    .glassEffect(.regular.tint(.white.opacity(0.08)).interactive())
            }
        }
    }
#endif
