//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A more prominent divider (horizontal or vertical) than the standard Divider().
public struct ProminentDivider: View {

    /// Creates the divider.
    public init() {}

    public var body: some View {
        Divider()
            .overlay(Color.primary.opacity(0.35))
    }
}
