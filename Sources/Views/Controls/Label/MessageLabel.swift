//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation
import Motley
import SwiftUI

/// A message's text with its kind symbol beside it, sized for a status line.
public struct MessageLabel: View {

    private let text: String
    private let symbol: SFSymbol?
    private let tint: Color

    public init(_ message: Message, prefixTitle: Bool = false) {
        self.text =
            if prefixTitle, let title = message.title {
                "\(title) – \(message.summary)"
            } else {
                message.summary
            }
        self.symbol = message.kind.labelSymbol
        self.tint = message.kind.symbolTint
    }

    public var body: some View {
        SymbolLabel(
            verbatim: text,
            symbol: symbol,
            tint: .monochrome(tint),
            layout: .inline,
        )
    }
}
