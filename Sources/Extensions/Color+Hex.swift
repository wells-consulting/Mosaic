//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension Color {

    /// A color written as `#RRGGBB` or `#RRGGBBAA`, as style files often do.
    ///
    /// Returns `nil` when the string isn't a color.
    init?(hex: String) {
        guard hex.hasPrefix("#") else {
            return nil
        }

        let digits = hex.dropFirst()
        guard digits.count == 6 || digits.count == 8,
            let value = UInt32(digits, radix: 16)
        else {
            return nil
        }

        let hasAlpha = digits.count == 8

        self.init(
            .sRGB,
            red: Double((value >> (hasAlpha ? 24 : 16)) & 0xFF) / 255,
            green: Double((value >> (hasAlpha ? 16 : 8)) & 0xFF) / 255,
            blue: Double((value >> (hasAlpha ? 8 : 0)) & 0xFF) / 255,
            opacity: hasAlpha ? Double(value & 0xFF) / 255 : 1
        )
    }
}
