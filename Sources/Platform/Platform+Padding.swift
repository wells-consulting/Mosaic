//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

extension Platform {

    // MARK: Semantic

    /// Semantic padding scale. Use `Theme.padding(.medium)` for CGFloat contexts
    /// (spacing: parameters, calculated values) and `.appPadding(.medium)` for
    /// SwiftUI `.padding()` call sites.
    ///
    /// Values are platform-aware — tvOS uses larger spacing for comfortable
    /// viewing at a distance on large screens.
    ///
    /// | Step   | iOS | tvOS | Use                                       |
    /// |--------|-----|------|-------------------------------------------|
    /// | xsmall |   4 |    6 | Fine label gaps, badge vertical inset     |
    /// | small  |   8 |   12 | Badge/pill inner padding                  |
    /// | medium |  12 |   16 | Metadata row spacing                      |
    /// | large  |  16 |   24 | Section padding, card region separation   |
    /// | xlarge |  24 |   36 | Form field padding, generous section gaps |
    public enum PaddingSize {
        case xsmall
        case small
        case medium
        case large
        case xlarge
        fileprivate var value: CGFloat {
            #if os(tvOS)
                switch self {
                case .xsmall: 8
                case .small: 12
                case .medium: 16
                case .large: 24
                case .xlarge: 36
                }
            #else
                switch self {
                case .xsmall: 4
                case .small: 8
                case .medium: 12
                case .large: 16
                case .xlarge: 24
                }
            #endif
        }
    }

    public static func padding(_ size: PaddingSize) -> CGFloat {
        size.value
    }
}

// MARK: - View Extensions

public extension View {

    func platformPadding(
        _ edges: Edge.Set = .all,
        _ size: Platform.PaddingSize,
    ) -> some View {
        padding(edges, Platform.padding(size))
    }

    func platformPadding(
        _ size: Platform.PaddingSize,
    ) -> some View {
        padding(Platform.padding(size))
    }
}
