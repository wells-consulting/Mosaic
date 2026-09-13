//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A menu whose trigger is a single SF symbol image.
///
/// Centralises icon-only menu styling: `accessibilityLabel` is required here
/// so it cannot be accidentally omitted. Platform-level visual treatment
/// (glass pill effect, padding) is applied internally via `appGlassMenuStyle()`.
/// `tint` tints the trigger image to signal a non-default active state.
public struct SymbolMenu<Content: View>: View {

    let symbol: SFSymbol
    let label: String
    let tint: Color?
    let content: () -> Content

    public init(
        _ symbol: SFSymbol,
        label: String,
        tint: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.symbol = symbol
        self.label = label
        self.tint = tint
        self.content = content
    }

    public var body: some View {
        Menu {
            content()
        } label: {
            Group {
                if let tint {
                    Image(symbol).foregroundStyle(tint)
                } else {
                    Image(symbol)
                }
            }
            .glassMenuContent()
        }
        .accessibilityLabel(label)
    }
}
