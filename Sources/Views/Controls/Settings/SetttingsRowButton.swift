//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public struct SettingsRowButton: View {

    #if os(iOS)
        @Environment(\.verticalSizeClass) private var vSizeClass
    #endif

    public enum Text {
        case fixed(String?)
        case adjustable(full: String?, abbreviated: String?)
        var text: String? {
            switch self {
            case let .fixed(string): string
            case let .adjustable(string, _): string
            }
        }
        #if os(iOS)
            func text(for sizeClass: UserInterfaceSizeClass?) -> String? {
                switch self {
                case let .fixed(string): string
                case let .adjustable(long, short):
                    sizeClass == .compact ? long : short
                }
            }
        #endif
    }

    private let symbol: SFSymbol
    private let text: LocalizedStringKey
    private let badge: Text?
    private let chevron: Bool
    private let value: Text?
    private let alignment: Alignment
    private let action: () -> Void

    public init(
        _ text: LocalizedStringKey,
        symbol: SFSymbol,
        badge: Text? = nil,
        value: Text? = nil,
        chevron: Bool = true,
        alignment: Alignment = .center,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.symbol = symbol
        self.badge = badge
        self.chevron = chevron
        self.value = value
        self.alignment = alignment
        self.action = action
    }

    public init(
        verbatim label: String,
        symbol: SFSymbol,
        badge: Text? = nil,
        value: Text? = nil,
        chevron: Bool = true,
        action: @escaping () -> Void
    ) {
        self.init(
            LocalizedStringKey(label),
            symbol: symbol,
            badge: badge,
            value: value,
            chevron: chevron,
            action: action
        )
    }

    private var detailString: String? {
        #if os(iOS)
            value?.text(for: vSizeClass)
        #else
            value?.text
        #endif
    }

    private var badgeString: String? {
        #if os(iOS)
            badge?.text(for: vSizeClass)
        #else
            badge?.text
        #endif
    }

    public var body: some View {
        Button {
            action()
        } label: {
            SymbolLabel(
                text,
                symbol: symbol,
                symbolPalette: (.secondary, .secondary.opacity(0.75)),
                details: detailString,
                badge: badgeString,
                addChevron: chevron,
            )
            .frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}
