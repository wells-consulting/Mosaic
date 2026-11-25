//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation

public extension Platform {

    /// Semantic corner radius scale used across all views.
    ///
    /// Pick the tier that matches the visual weight of the element:
    /// - `small`  (8)  — badges, pills, shimmer bars, small inset clips
    /// - `medium` (12) — thumbnails, shelf cards, settings info cards (iOS)
    /// - `large`  (16) — panels, modals, settings info cards (tvOS)
    /// - `xlarge` (20) — grid cards, primary row buttons
    enum CornerRadius: CGFloat {
        case small = 8
        case medium = 12
        case large = 16
        case xlarge = 20
    }

    /// Returns the points for a corner radius step.
    static func cornerRadius(_ size: CornerRadius) -> CGFloat {
        size.rawValue
    }
}
