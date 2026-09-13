//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation
import Motley
import SwiftUI

public struct MessageLabel: View {

    private let text: String
    private let symbol: SFSymbol
    private let symbolTint: Color

    init(_ message: Message) {
        self.text = message.summary
        self.symbol = message.kind.symbol
        switch message.kind {
        case .info:
            self.symbolTint = Color.secondary
        case .warning:
            self.symbolTint = PaletteStore.shared.palette.warningLabel
        case .error:
            self.symbolTint = PaletteStore.shared.palette.errorLabel
        }
    }

    public var body: some View {
        HStack {
            Image(symbol)
                .foregroundStyle(symbolTint)
            Text(text)
        }
        .imageScale(.medium)
    }
}
