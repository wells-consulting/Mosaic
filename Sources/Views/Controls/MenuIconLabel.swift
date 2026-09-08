//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// This standard view ensures the icon in a menu item label occupies a consistent width
public struct MenuIconLabel: View {

    private let textView: Text
    let symbol: SFSymbol?
    let symbolPalette: (Color, Color)
    let imageScale: Image.Scale
    let detail: String?
    let badgeText: String?
    let withChevron: Bool

    public init(
        _ text: LocalizedStringKey,
        symbol: SFSymbol? = nil,
        symbolPalette: (Color, Color)? = nil,
        detail: String? = nil,
        badge: String? = nil,
        withChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.textView = Text(text)
        self.symbol = symbol
        self.symbolPalette = symbolPalette ?? (.primary, .secondary)
        self.detail = detail
        self.badgeText = badge
        self.withChevron = withChevron
        self.imageScale = imageScale
    }

    /// Creates a menu label with verbatim (non-localizable) text.
    public init(
        verbatim: String,
        symbol: SFSymbol? = nil,
        symbolPalette: (Color, Color)? = nil,
        detail: String? = nil,
        badge: String? = nil,
        withChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.init(
            LocalizedStringKey(verbatim),
            symbol: symbol,
            symbolPalette: symbolPalette,
            detail: detail,
            badge: badge,
            withChevron: withChevron,
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
            if detail != nil || withChevron {
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
        if let detail {
            Text(detail)
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
        if withChevron {
            Chevron()
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        Button {
        } label: {
            MenuIconLabel(
                "Title for the button",
                symbol: .gear,
                detail: "Details",
                badge: "TEST",
                withChevron: true,
            )
        }
        .frame(width: 800)
    }
#endif
