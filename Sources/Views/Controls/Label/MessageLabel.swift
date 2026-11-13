//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation
import Motley
import SwiftUI

public struct MessageLabel: View {

    private let text: String
    private let symbol: SFSymbol?
    private let symbolTint: Color?

    public init(_ message: Message, prefixTitle: Bool = false) {
        self.text = if prefixTitle, let title = message.title {
            "\(title) – \(message.summary)"
        } else {
            message.summary
        }
        if message.kind == .text {
            self.symbol = nil
            self.symbolTint = nil
        } else {
            self.symbol = message.kind.symbol
            self.symbolTint = message.kind.symbolTint
        }
    }

    public var body: some View {
        HStack {
            if let symbol, let symbolTint {
                Image(symbol)
                    .foregroundStyle(symbolTint)
            }
            Text(text)
                .mosaicEnableTextSelection()
        }
        .imageScale(.medium)
    }
}
