//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A faint horizontal divider used between rows in informational cards
/// (Settings, Insights, Diagnostics). The system `Divider` is too prominent;
/// dropping it to 15% opacity matches the design language used app-wide.
public struct SubtleDivider: View {

    /// Creates the divider.
    public init() {}
    public var body: some View {
        Divider()
            .opacity(0.15)
    }
}
