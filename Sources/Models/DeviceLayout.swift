//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation

/// Describes the device form factor and rendered geometry for layout decisions.
///
/// Prefer `@Environment(\.layout)` over raw `horizontalSizeClass`/`verticalSizeClass`
/// checks. `DeviceLayout` disambiguates form factors and geometry without conflating size
/// classes with orientation: case names describe the rendered content area's shape
/// (tall vs. wide), not the physical device orientation.
///
/// Injected at the app root by `.mosaicInjectDeviceLayoutEnvironment()`. The
/// default environment value is `.padWide`, which is a safe fallback for tvOS
/// and macOS.
public enum DeviceLayout: Sendable {

    /// Phone with a taller-than-wide content area.
    case phoneTall

    /// Phone with a wider-than-tall content area.
    case phoneWide

    /// iPad at full or nearly-full width, with height exceeding width.
    case padTall

    /// iPad at full or nearly-full width, with width exceeding height.
    case padWide

    /// iPad in a narrow split-view column (compact horizontal, regular vertical).
    case padCompact

    // MARK: - Convenience

    /// True for a phone in either orientation.
    public var isPhone: Bool {
        self == .phoneTall || self == .phoneWide
    }

    /// True for an iPad at full width or in a split view.
    public var isPad: Bool {
        self == .padTall || self == .padWide || self == .padCompact
    }

    /// True when the rendered content area is taller than wide.
    public var isTall: Bool {
        self == .phoneTall || self == .padTall
    }

    /// True when the rendered content area is wider than tall.
    public var isWide: Bool {
        self == .phoneWide || self == .padWide
    }

    /// True when horizontal space is tight enough to warrant dropping button labels or icons.
    /// Covers phone tall layout and iPad narrow split view.
    public var widthConstrained: Bool {
        self == .phoneTall || self == .padCompact
    }

    /// True when vertical space is tight enough to warrant dropping spacing or icon sizes.
    public var heightConstrained: Bool {
        self == .phoneWide
    }
}
