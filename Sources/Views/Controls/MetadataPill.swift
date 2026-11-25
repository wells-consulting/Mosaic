//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation
import Motley
import SwiftUI

/// A capsule-shaped label combining an SF Symbol icon and a text string.
/// Used to display resolution, codec, frame rate, file size, and similar
/// technical metadata at a glance.
public struct MetadataPill: View {

    let text: String
    let symbol: SFSymbol

    /// - Parameters:
    ///   - text: The value to show.
    ///   - symbol: The icon before it.
    public init(text: String, symbol: SFSymbol) {
        self.text = text
        self.symbol = symbol
    }

    public var body: some View {
        HStack(spacing: Platform.spacing(.small)) {
            Image(symbol)
                .accessibilityHidden(true)
            Text(text)
        }
        .mosaicFont(.badge).bold()
        .foregroundStyle(.primary.opacity(0.85))
        .padding(.horizontal, 20)
        .mosaicPadding(.vertical, .xsmall)
        .background(.primary.opacity(0.15), in: Capsule())
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG

    #Preview {
        MetadataPill(text: "1080p", symbol: .tv)
    }

#endif
