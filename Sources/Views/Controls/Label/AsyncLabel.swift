//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A `Label` that cross-fades between a symbol icon and a `ProgressView` spinner.
/// Use as the label inside a `Button` that drives an async operation.
public struct AsyncLabel: View {

    let title: String
    let symbol: SFSymbol
    let loading: Bool

    /// - Parameters:
    ///   - title: The label text.
    ///   - symbol: The icon shown when the work is idle.
    ///   - loading: Whether to show the spinner instead of the icon.
    public init(_ title: String, symbol: SFSymbol, loading: Bool) {
        self.title = title
        self.symbol = symbol
        self.loading = loading
    }

    public var body: some View {
        Label {
            Text(title)
        } icon: {
            ZStack {
                Image(symbol)
                    .foregroundStyle(.secondary)
                    .opacity(loading ? 0 : 1)
                ProgressView().controlSize(.small)
                    .opacity(loading ? 1 : 0)
            }
        }
    }
}
