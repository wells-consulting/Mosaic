//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public struct Chevron: View {

    public var style: AnyShapeStyle

    public init() {
        style = AnyShapeStyle(.tertiary)
    }

    public init<S: ShapeStyle>(_ style: S) {
        self.style = AnyShapeStyle(style)
    }

    public var body: some View {
        Image(.chevron_right)
            .imageScale(.small)
            .foregroundStyle(style)
            .platformPadding(.leading, .small)
    }
}
