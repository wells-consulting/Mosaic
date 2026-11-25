//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

@available(
    *,
    deprecated,
    message: "Use SymbolLabel with tint: .monochrome(.secondary) and layout: .inline."
)
/// A symbol and a title in the secondary color.
///
/// Deprecated. Use `SymbolLabel` with `.monochrome(.secondary)` and
/// `.inline`.
public struct MutedSymbolLabel: View {

    let title: LocalizedStringKey
    let symbol: SFSymbol

    /// - Parameters:
    ///   - title: The label text.
    ///   - symbol: The icon before it.
    public init(_ title: LocalizedStringKey, symbol: SFSymbol) {
        self.title = title
        self.symbol = symbol
    }

    /// - Parameters:
    ///   - title: The label text, as written.
    ///   - symbol: The icon before it.
    public init(_ title: String, symbol: SFSymbol) {
        self.title = LocalizedStringKey(title)
        self.symbol = symbol
    }

    public var body: some View {
        SymbolLabel(
            title,
            symbol: symbol,
            tint: .monochrome(.secondary),
            layout: .inline,
        )
    }
}
