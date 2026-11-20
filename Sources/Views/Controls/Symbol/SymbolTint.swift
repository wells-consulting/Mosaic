//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// How a symbol's layers are colored.
///
/// The colors come with the mode they belong to, so you can't hand a palette
/// one color or a single tint three.
public struct SymbolTint: Hashable, Sendable {

    enum Kind: Hashable, Sendable {
        case monochrome(Color)
        case hierarchical(Color)
        case palette(Color, Color, Color?)
        case multicolor
    }

    let kind: Kind

    private init(_ kind: Kind) {
        self.kind = kind
    }

    /// One color for every layer. This is Apple's default mode.
    public static func monochrome(_ color: Color) -> Self {
        Self(.monochrome(color))
    }

    /// One color, dimmed through the symbol's layers.
    public static func hierarchical(_ color: Color) -> Self {
        Self(.hierarchical(color))
    }

    /// One color per layer. Two covers most symbols; a few want three.
    public static func palette(_ first: Color, _ second: Color) -> Self {
        Self(.palette(first, second, nil))
    }

    public static func palette(_ first: Color, _ second: Color, _ third: Color) -> Self {
        Self(.palette(first, second, third))
    }

    /// Keeps the colors the symbol was drawn with and ignores the foreground style.
    public static var multicolor: Self {
        Self(.multicolor)
    }
}

extension SymbolTint {

    @ViewBuilder
    func apply(to image: some View) -> some View {
        switch kind {
        case .monochrome(let color):
            image
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(color)
        case .hierarchical(let color):
            image
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(color)
        case .palette(let first, let second, let third):
            if let third {
                image
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(first, second, third)
            } else {
                image
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(first, second)
            }
        case .multicolor:
            image.symbolRenderingMode(.multicolor)
        }
    }
}

#if os(tvOS)
    extension SymbolTint {
        /// On focus the row sits on white, so the symbol goes black with it.
        var focused: Self {
            switch kind {
            case .monochrome:
                .monochrome(.black)
            case .hierarchical:
                .hierarchical(.black)
            case .palette(_, _, let third):
                if third == nil {
                    .palette(.black, .black.opacity(0.6))
                } else {
                    .palette(.black, .black.opacity(0.6), .black.opacity(0.4))
                }
            case .multicolor:
                .multicolor
            }
        }
    }
#endif
