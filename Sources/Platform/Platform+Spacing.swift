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
}
