//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// Sizing tier for `MosaicProminenceButtonStyle`.
///
/// `large` is the media-player look the style was built for: generous
/// padding, touch-sized floors, grain texture. `compact` is the typical-app
/// tier: tighter padding, shorter floors, flat fill. Defaults keep every
/// existing call site on `large`.
public enum ButtonDensity: Sendable {

    case large
    case compact

    var horizontalPadding: CGFloat {
        switch self {
        case .large:
            20
        case .compact:
            12
        }
    }

    /// Floor, not fixed height, so a Dynamic Type-scaled label can still
    /// grow the button taller. Large keeps the media-player values: HIG's
    /// 44pt touch floor on iOS; macOS uses a much shorter 36pt floor since
    /// pointer-driven controls need no touch-sized target, yet System
    /// Settings' filled buttons are generous, so it stays well above the
    /// ~22pt native bordered height; tvOS stays 66pt for the focus engine.
    /// Compact keeps the same ordering at shorter values.
    var minHeight: CGFloat {
        switch self {
        case .large:
            #if os(iOS)
                44
            #elseif os(macOS)
                36
            #elseif os(tvOS)
                66
            #endif
        case .compact:
            #if os(iOS)
                32
            #elseif os(macOS)
                24
            #elseif os(tvOS)
                48
            #endif
        }
    }
}
