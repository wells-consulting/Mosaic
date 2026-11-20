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
public struct MutedSymbolLabel: View {

    let title: LocalizedStringKey
    let symbol: SFSymbol

    public init(_ title: LocalizedStringKey, symbol: SFSymbol) {
        self.title = title
        self.symbol = symbol
    }

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
