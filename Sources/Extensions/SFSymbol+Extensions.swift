//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

// MARK: - Image

extension Image {

    /// Creates an image from a Motley symbol.
    public init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}

// MARK: - Label

extension Label where Title == Text, Icon == Image {

    /// Creates a label from a localized title and a Motley symbol.
    public init(_ titleKey: LocalizedStringKey, symbol: SFSymbol) {
        self.init(titleKey, systemImage: symbol.rawValue)
    }

    /// Creates a label from a string and a Motley symbol.
    public init(_ title: some StringProtocol, symbol: SFSymbol) {
        self.init(title, systemImage: symbol.rawValue)
    }
}

// MARK: - Toggle

extension Toggle where Label == SwiftUI.Label<Text, Image> {

    /// Creates a toggle from a localized title, a Motley symbol and a binding.
    public init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        isOn: Binding<Bool>,
    ) {
        self.init(titleKey, systemImage: symbol.rawValue, isOn: isOn)
    }

    /// Creates a toggle from a string, a Motley symbol and a binding.
    public init(
        _ title: some StringProtocol,
        symbol: SFSymbol,
        isOn: Binding<Bool>,
    ) {
        self.init(title, systemImage: symbol.rawValue, isOn: isOn)
    }
}
