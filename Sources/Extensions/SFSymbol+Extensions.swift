//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

// MARK: - Image

extension Image {
    public init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}

// MARK: - Label

extension Label where Title == Text, Icon == Image {

    public init(_ titleKey: LocalizedStringKey, symbol: SFSymbol) {
        self.init(titleKey, systemImage: symbol.rawValue)
    }

    public init(_ title: some StringProtocol, symbol: SFSymbol) {
        self.init(title, systemImage: symbol.rawValue)
    }
}

// MARK: - Toggle

extension Toggle where Label == SwiftUI.Label<Text, Image> {
    public init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        isOn: Binding<Bool>,
    ) {
        self.init(titleKey, systemImage: symbol.rawValue, isOn: isOn)
    }

    public init(
        _ title: some StringProtocol,
        symbol: SFSymbol,
        isOn: Binding<Bool>,
    ) {
        self.init(title, systemImage: symbol.rawValue, isOn: isOn)
    }
}
