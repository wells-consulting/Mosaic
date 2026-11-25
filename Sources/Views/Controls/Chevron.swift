//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A small right-pointing chevron for a row that opens something.
public struct Chevron: View {

    /// The chevron's color.
    public var style: AnyShapeStyle

    /// A chevron in the tertiary color.
    public init() {
        style = AnyShapeStyle(.tertiary)
    }

    /// A chevron in a color you choose.
    public init<S: ShapeStyle>(_ style: S) {
        self.style = AnyShapeStyle(style)
    }

    public var body: some View {
        Image(.chevron_right)
            .imageScale(.small)
            .foregroundStyle(style)
            .mosaicPadding(.leading, .small)
    }
}
