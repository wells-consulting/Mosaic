//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Foundation
import Motley
import SwiftUI

public extension Message.Kind {

    /// The symbol a message shows beside its text. A `.text` message has none.
    var labelSymbol: SFSymbol? {
        self == .text ? nil : symbol
    }

    /// The label color for the message's kind.
    @MainActor
    var symbolTint: Color {
        switch self {
        case .text: .accentColor
        case .info: .secondary
        case .notice: PaletteStore.shared.current.warningLabel
        case .error: PaletteStore.shared.current.errorLabel
        }
    }

    /// The fill behind the message's kind, or clear.
    @MainActor
    var backgroundTint: Color {
        switch self {
        case .text, .info: .clear
        case .notice: PaletteStore.shared.current.warningTint
        case .error: PaletteStore.shared.current.errorTint
        }
    }
}
