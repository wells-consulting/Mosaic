//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension ButtonStyle where Self == MosaicGridButtonStyle {
    /// A borderless button for a grid cell.
    static var mosaicGrid: MosaicGridButtonStyle {
        .init()
    }
}

/// A borderless button style for grid cells. It adds no background or padding,
/// so the cell's own content draws the shape.
public struct MosaicGridButtonStyle: ButtonStyle {

    /// Creates the grid button style.
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // pad-audit: keep — fixed offset (not on the Platform padding scale)
            .padding(0)
            .background(Color.clear)
    }
}
