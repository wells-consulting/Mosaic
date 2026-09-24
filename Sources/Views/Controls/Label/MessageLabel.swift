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

    public init(_ message: Message) {
        self.text = message.summary
        switch message.kind {
        case .text:
            self.symbol = nil
            self.symbolTint = nil
        case .info:
            self.symbol = message.kind.symbol
            self.symbolTint = Color.secondary
        case .notice:
            self.symbol = message.kind.symbol
            self.symbolTint = PaletteStore.shared.current.warningLabel
        case .error:
            self.symbol = message.kind.symbol
            self.symbolTint = PaletteStore.shared.current.errorLabel
        }
    }

    public var body: some View {
        HStack {
            if let symbol, let symbolTint {
                Image(symbol)
                    .foregroundStyle(symbolTint)
            }
            Text(text)
        }
        .imageScale(.medium)
    }
}
