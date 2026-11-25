//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// Builds a card of label and value rows, for a small table of facts.
public final class SettingsTableBuilder {

    /// One row in the table.
    public enum TableRow: Hashable {

        /// A label and its value.
        case textLabel(String, String)

        /// An icon, a label and a value.
        case symbolLabel(String, String, SFSymbol)

        /// A line of text on its own.
        case text(String)
    }

    private var rows: [TableRow]

    /// Creates an empty table.
    public init() {
        self.rows = []
    }

    /// Adds a line of text on its own.
    public func addRow(_ text: String) {
        rows.append(.text(text))
    }

    /// Adds a label and a value, with an optional icon before the label.
    public func addRow(_ text: String, _ value: String, symbol: SFSymbol? = nil) {
        if let symbol {
            rows.append(.symbolLabel(text, value, symbol))
        } else {
            rows.append(.textLabel(text, value))
        }
    }

    /// Renders the rows in a card.
    ///
    /// - Parameter spacing: The gap between rows. Defaults to 16 points.
    @MainActor
    public func build(spacing: CGFloat = 16) -> some View {
        SettingsCard {
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(rows.enumerated(), id: \.offset) { index, row in
                    if index > 0 {
                        SubtleDivider()
                    }
                    switch row {
                    case let .text(text):
                        Text(text)
                            .mosaicFont(.caption)
                            .foregroundStyle(.secondary)
                    case let .textLabel(text, value):
                        HStack {
                            Text(text)
                            Spacer()
                            Text(value)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    case let .symbolLabel(text, value, symbol):
                        HStack {
                            Image(symbol)
                                .imageScale(.small)
                                .foregroundStyle(.secondary)
                                .frame(width: 20, alignment: .center)
                            Text(text)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(value)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}
