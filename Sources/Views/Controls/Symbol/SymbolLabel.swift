//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A symbol and its text, with the icon tinted separately from the words.
/// `.column` gives the icon the same width in every row; `.inline` sits it
/// next to the text, for a status line.
public struct SymbolLabel: View {

    /// Where the symbol sits beside the text.
    public enum Layout: Hashable, Sendable {
        /// The icon takes a fixed column, so labels stack with their text lined up.
        case column
        /// The icon sits at its own width, close to the text.
        case inline
    }

    private let textView: Text
    let symbol: SFSymbol?
    let tint: SymbolTint
    let layout: Layout
    let imageScale: Image.Scale
    let details: String?
    let badgeText: String?
    let includeChevron: Bool

    /// - Parameters:
    ///   - text: The label text.
    ///   - symbol: The icon before the text.
    ///   - tint: How the icon's layers are colored.
    ///   - layout: Whether the icon takes a column or sits inline.
    ///   - details: A second line under the text.
    ///   - badge: A short value after the text.
    ///   - addChevron: Whether to add a trailing chevron.
    ///   - imageScale: The icon's scale.
    public init(
        _ text: LocalizedStringKey,
        symbol: SFSymbol? = nil,
        tint: SymbolTint = .palette(.primary, .secondary),
        layout: Layout = .column,
        details: String? = nil,
        badge: String? = nil,
        addChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.textView = Text(text)
        self.symbol = symbol
        self.tint = tint
        self.layout = layout
        self.details = details
        self.badgeText = badge
        self.includeChevron = addChevron
        self.imageScale = imageScale
    }

    /// Creates a label with verbatim (non-localizable) text, such as a file
    /// name.
    ///
    /// - Parameters:
    ///   - verbatim: The text to show as written.
    ///   - symbol: The icon before the text.
    ///   - tint: How the icon's layers are colored.
    ///   - layout: Whether the icon takes a column or sits inline.
    ///   - details: A second line under the text.
    ///   - badge: A short value after the text.
    ///   - addChevron: Whether to add a trailing chevron.
    ///   - imageScale: The icon's scale.
    public init(
        verbatim: String,
        symbol: SFSymbol? = nil,
        tint: SymbolTint = .palette(.primary, .secondary),
        layout: Layout = .column,
        details: String? = nil,
        badge: String? = nil,
        addChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.init(
            LocalizedStringKey(verbatim),
            symbol: symbol,
            tint: tint,
            layout: layout,
            details: details,
            badge: badge,
            addChevron: addChevron,
            imageScale: imageScale,
        )
    }

    /// Creates a label for a message, using the message's summary, symbol and
    /// tint.
    ///
    /// - Parameters:
    ///   - message: The message to show.
    ///   - tint: An override for the message kind's tint.
    ///   - layout: Whether the icon takes a column or sits inline.
    ///   - badge: A short value after the text.
    ///   - addChevron: Whether to add a trailing chevron.
    ///   - imageScale: The icon's scale.
    public init(
        _ message: Message,
        tint: SymbolTint? = nil,
        layout: Layout = .column,
        badge: String? = nil,
        addChevron: Bool = false,
        imageScale: Image.Scale = .medium,
    ) {
        self.init(
            LocalizedStringKey(message.summary),
            symbol: message.kind.labelSymbol,
            tint: tint ?? .monochrome(message.kind.symbolTint),
            layout: layout,
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
        HStack(spacing: layout == .inline ? Platform.spacing(.small) : 0) {
            symbolImage
            if layout == .inline {
                textView
                    .mosaicEnableTextSelection()
            } else {
                textView
            }
            badge
            if details != nil || includeChevron {
                Spacer(minLength: 0)
                detailText
                chevron
            }
        }
    }

    /// On tvOS focus the row's highlight is white, so the symbol goes black.
    private var shownTint: SymbolTint {
        #if os(tvOS)
            if isFocused { return tint.focused }
        #endif
        return tint
    }

    @ViewBuilder
    private var symbolImage: some View {
        if let symbol {
            if layout == .column {
                icon(symbol)
                    .frame(width: iconWidth, alignment: .center)
                    #if os(tvOS)
                        .padding(.trailing, 12)
                    #endif
            } else {
                icon(symbol)
            }
        }
    }

    private func icon(_ symbol: SFSymbol) -> some View {
        shownTint.apply(to: Image(symbol).imageScale(imageScale))
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var detailText: some View {
        if let details {
            Text(details)
                .foregroundStyle(.secondary)
                .mosaicEnableTextSelection()
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

    #Preview("Tints") {
        VStack(alignment: .leading) {
            SymbolLabel("Monochrome", symbol: .gear, tint: .monochrome(.accentColor))
            SymbolLabel("Hierarchical", symbol: .gear, tint: .hierarchical(.accentColor))
            SymbolLabel("Palette", symbol: .gear, tint: .palette(.accentColor, .orange))
            SymbolLabel("Multicolor", symbol: .gear, tint: .multicolor)
        }
        .frame(width: 400)
    }

    #Preview("Inline") {
        VStack(alignment: .leading, spacing: Platform.spacing(.small)) {
            SymbolLabel(
                "Analyze Library",
                symbol: .list_bullet_rectangle,
                tint: .monochrome(.secondary),
                layout: .inline,
            )
            SymbolLabel(
                "Delete",
                symbol: .trash,
                tint: .monochrome(.red),
                layout: .inline,
            )
        }
    }
#endif
