//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension Color {

    /// Creates an adaptive color that switches between `light` and `dark` by appearance.
    ///
    /// `Color(red:green:blue:)` and friends are "constant" colors that do not change
    /// with context — unlike a color loaded from an asset catalog. This initializer
    /// recreates that adaptivity by wrapping a dynamic `UIColor`/`NSColor`, which
    /// resolves against the host trait environment and redraws on appearance change.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
            self.init(uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
            })
        #elseif canImport(AppKit)
            self.init(nsColor: NSColor(name: nil) { appearance in
                appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                    ? NSColor(dark)
                    : NSColor(light)
            })
        #endif
    }

    /// Returns `color` unchanged. Marks single-appearance roles explicitly and
    /// spares them the cost of a dynamic provider while both appearances match.
    static func constant(_ color: Color) -> Color {
        color
    }
}
