//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A filled, bordered card, styled from the active palette.
///
/// Lighter than `mosaicTileBackground`, which has no border and doesn't read
/// the palette.
public struct CardPanel<Content: View>: View {

    /// How the border reads.
    public enum Emphasis: Sendable {

        /// The palette's ordinary card border.
        case normal

        /// A wider warning-colored border, for a card whose figure has a
        /// problem.
        case warning
    }

    private let padding: CGFloat
    private let emphasis: Emphasis
    private let content: Content

    public init(
        padding: Platform.PaddingSize = .medium,
        emphasis: Emphasis = .normal,
        @ViewBuilder content: () -> Content,
    ) {
        self.padding = Platform.padding(padding)
        self.emphasis = emphasis
        self.content = content()
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .background(PaletteStore.shared.current.cardFill)
            .clipShape(cardShape)
            .overlay(cardShape.stroke(borderColor, lineWidth: borderWidth))
    }

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Platform.cornerRadius(.large), style: .continuous)
    }

    private var borderColor: Color {
        switch emphasis {
        case .normal:
            PaletteStore.shared.current.cardBorder
        case .warning:
            WarningMark.borderColor
        }
    }

    private var borderWidth: CGFloat {
        switch emphasis {
        case .normal:
            1
        case .warning:
            WarningMark.borderWidth
        }
    }
}
