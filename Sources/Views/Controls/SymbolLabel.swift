//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// This standard view ensures the icon in a menu item label occupies a consistent width
public struct SymbolLabel: View {

    private let textView: Text
    let symbol: SFSymbol?
    let symbolPalette: (Color, Color)
    let imageScale: Image.Scale
    let details: String?
    let badgeText: String?
    let includeChevron: Bool

    public init(
        _ text: LocalizedStringKey,
        symbol: SFSymbol? = nil,
        symbolPalette: (Color, Color)? = nil,
        details: String? = nil,
        badge: String? = nil,
        addChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.textView = Text(text)
        self.symbol = symbol
        self.symbolPalette = symbolPalette ?? (.primary, .secondary)
        self.details = details
        self.badgeText = badge
        self.includeChevron = addChevron
        self.imageScale = imageScale
    }

    /// Creates a menu label with verbatim (non-localizable) text.
    public init(
        verbatim: String,
        symbol: SFSymbol? = nil,
        symbolPalette: (Color, Color)? = nil,
        details: String? = nil,
        badge: String? = nil,
        addChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.init(
            LocalizedStringKey(verbatim),
            symbol: symbol,
            symbolPalette: symbolPalette,
            details: details,
            badge: badge,
            addChevron: addChevron,
            imageScale: imageScale,
        )
    }

    /// Creates a menu label with verbatim (non-localizable) text.
    public init(
        _ message: Message,
        symbolPalette: (Color, Color)? = nil,
        badge: String? = nil,
        addChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.init(
            LocalizedStringKey(message.summary),
            symbol: message.kind.symbol,
            symbolPalette: symbolPalette,
            details: message.details,
            badge: badge,
            addChevron: addChevron,
            imageScale: imageScale,
        )
    }

    #if os(tvOS)
        @Environment(\.isFocused) private var isFocused
    #endif

    private var iconWidth: CGFloat {
        #if os(tvOS)
            48
        #else
            32
        #endif
    }

    public var body: some View {
        HStack(spacing: 0) {
            symbolImage
            textView
            badge
            if details != nil || includeChevron {
                Spacer(minLength: 0)
                detailText
                chevron
            }
        }
    }

    @ViewBuilder
    private var symbolImage: some View {
        if let symbol {
            let (paletteFirst, paletteSecond): (Color, Color) = {
                #if os(tvOS)
                    if isFocused { return (.black, .black.opacity(0.6)) }
                #endif
                return symbolPalette
            }()
            Image(symbol)
                .imageScale(imageScale)
                .symbolRenderingMode(.palette)
                .foregroundStyle(paletteFirst, paletteSecond)
                .frame(width: iconWidth, alignment: .center)
                #if os(tvOS)
                    .padding(.trailing, 12)
                #endif
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var detailText: some View {
        if let details {
            Text(details)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var badge: some View {
        if let badgeText {
            Text(badgeText)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 2)
                .foregroundStyle(.secondary)
                .overlay(Capsule().strokeBorder(.secondary, lineWidth: 3))
                .padding(.leading, 12)
                .padding(.bottom, -2)
        }
    }

    @ViewBuilder
    private var chevron: some View {
        if includeChevron {
            Chevron()
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        Button {
        } label: {
            SymbolLabel(
                "Title for the button",
                symbol: .gear,
                details: "Details",
                badge: "TEST",
                addChevron: true,
            )
        }
        .frame(width: 800)
    }
#endif
