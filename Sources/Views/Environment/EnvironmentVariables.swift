//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension EnvironmentValues {

    /// Layout context derived from device idiom and orientation. Injected at the app root
    /// by `.appInjectLayout()`. Use this instead of raw `horizontalSizeClass`/`verticalSizeClass`.
    @Entry var layout: DeviceLayout = .padWide

    /// Controls whether image cards fit or fill their square cell
    @Entry var imageContentMode: ContentMode = .fit

    #if os(iOS)
        /// Used with appScrollsToTop modifer
        @Entry var scrollToTopCoordinator: ScrollToTopCoordinator?

        /// True when the view is being rendered inside a `ButtonGroup`'s shared pill.
        /// Read by `appGlassButton()` and `appGlassMenuStyle()` to skip their own per-control
        /// glass surface so the parent's pill is the only glass layer visible.
        @Entry var insideButtonGroup: Bool = false
    #endif
}
