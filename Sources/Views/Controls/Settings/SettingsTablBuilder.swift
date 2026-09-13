//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public final class SettingsTableBuilder {

    public enum Row: Hashable {
        case textLabel(String, String)
        case symbolLabel(String, String, SFSymbol)
        case text(String)
    }

    private var rows: [Row] = []

    public func addRow(_ text: String) {
        rows.append(.text(text))
    }

    public func addRow(_ text: String, _ value: String, symbol: SFSymbol? = nil) {
        if let symbol {
            rows.append(.symbolLabel(text, value, symbol))
        } else {
            rows.append(.textLabel(text, value))
        }
    }

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
                            .platformFont(.caption)
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
