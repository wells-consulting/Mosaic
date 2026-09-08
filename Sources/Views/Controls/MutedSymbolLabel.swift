//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

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
        HStack(spacing: Platform.spacing(.small)) {
            Image(symbol)
                .foregroundStyle(.secondary)
            Text(title)
        }
    }
}
