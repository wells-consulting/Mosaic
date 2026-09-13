//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation

extension Platform {

    /// Semantic spacing for inter-element gaps (VStack, HStack, grids).
    ///
    /// Values are platform-aware — tvOS uses larger spacing for comfortable
    /// viewing at a distance on large screens.
    ///
    /// | Step     | iOS | tvOS | Use                                        |
    /// |----------|-----|------|--------------------------------------------|
    /// | xsmall   |   4 |    8 | Fine label gaps, stats rows, badge insets  |
    /// | small    |   8 |   12 | Metadata row spacing, small item gaps      |
    /// | medium   |  12 |   20 | Field spacing, moderate content separation |
    /// | standard |  16 |   24 | Header-to-content, moderate section gaps   |
    /// | large    |  20 |   32 | Grid spacing, section separation           |
    /// | xlarge   |  32 |   48 | Form sections, generous content gaps       |
    public enum SpacingSize {
        case xsmall
        case small
        case medium
        case standard
        case large
        case xlarge
        fileprivate var value: CGFloat {
            #if os(tvOS)
                switch self {
                case .xsmall: 8
                case .small: 12
                case .medium: 20
                case .standard: 24
                case .large: 32
                case .xlarge: 48
                }
            #else
                switch self {
                case .xsmall: 4
                case .small: 8
                case .medium: 12
                case .standard: 16
                case .large: 20
                case .xlarge: 32
                }
            #endif
        }
    }

    public static func spacing(_ size: SpacingSize) -> CGFloat {
        size.value
    }

    // MARK: Context

    public enum SpacingContext {

        /// Spacing for rows in header bar
        case headerBarVertical
        /// Spacing between the "< Settings" dismiss button and the page content below it.
        /// tvOS needs extra room so the button's focus highlight doesn't overlap the
        /// first content row's section label.
        case settingsDismissButton
        /// Vertical spacing between menu items.
        case settingsMenu
        /// Horizontal spacing between cards in a featured swimlane row.
        /// tvOS needs wider gaps for the focus scale effect.
        case swimlaneCard
        /// Minimal spacing between stacked text lines in compact layouts
        /// (title + subtitle pairs, badge stacks). 2pt.
        case tightLine

        fileprivate var value: CGFloat {
            switch self {
            case .headerBarVertical:
                12
            case .settingsDismissButton:
                #if os(tvOS)
                    52
                #else
                    16
                #endif
            case .settingsMenu:
                #if os(tvOS)
                    16
                #else
                    12
                #endif
            case .swimlaneCard:
                #if os(tvOS)
                    40
                #else
                    20
                #endif
            case .tightLine:
                2
            }
        }
    }

    public static func spacing(_ context: SpacingContext) -> CGFloat {
        context.value
    }
}
