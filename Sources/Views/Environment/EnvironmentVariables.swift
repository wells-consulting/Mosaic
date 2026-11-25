//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension EnvironmentValues {

    /// Layout context derived from device idiom and orientation. Injected at the app root
    /// by `.mosaicInjectDeviceLayoutEnvironment()`. Use this instead of raw
    /// `horizontalSizeClass`/`verticalSizeClass`.
    @Entry var layout: DeviceLayout = .padWide

    /// The room the nearest `.mosaicMeasuresContainerLayout()` container
    /// measured, for decisions that depend on one container and not the device.
    @Entry var containerLayout: ContainerLayout = .fallback

    /// Controls whether image cards fit or fill their square cell
    @Entry var imageContentMode: ContentMode = .fit

    #if os(iOS)
        /// Used with the `mosaicScrollsToTop` modifier.
        @Entry var scrollToTopCoordinator: MosaicScrollToTopCoordinator?

        /// True when the view is being rendered inside a `ButtonGroup`'s shared pill.
        /// Read by `mosaicGlassButtonStyle()` and `mosaicGlassMenuContent()` to skip their
        /// own per-control glass surface so the parent's pill is the only glass layer visible.
        @Entry var insideButtonGroup: Bool = false

        /// True inside a settings page that already insets its content to the
        /// settings column. Read by `SettingsColumnModifier` so nested pages
        /// don't inset twice.
        @Entry var insideSettingsColumn: Bool = false
    #endif
}
