//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// The line between grouped rows. tvOS doesn't draw rows like that and has
    /// no modifier for it; its lists are the dashboard.
    func mosaicListRowSeparator() -> some View {
        #if os(tvOS)
            self
        #else
            listRowSeparator(.hidden)
        #endif
    }

    /// The checkbox a Mac draws for a toggle, where the platform has one.
    func mosaicCheckboxToggleStyle() -> some View {
        #if os(macOS)
            toggleStyle(.checkbox)
        #else
            self
        #endif
    }
}

#if !os(macOS)
    public extension CGColor {

        /// The platform's own `CGColor.black` isn't there on iOS and tvOS.
        static let black = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
#endif
