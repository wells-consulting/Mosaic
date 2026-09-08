//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public struct GridButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // pad-audit: keep — fixed offset (not on the Platform padding scale)
            .padding(0)
            .background(Color.clear)
    }
}

public extension ButtonStyle where Self == GridButtonStyle {
    static var gridButtonStyle: GridButtonStyle {
        .init()
    }
}
