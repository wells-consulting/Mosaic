//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public struct SettingsToggleBar: View {

    private let title: String
    private let details: String?
    private let symbol: SFSymbol?

    @Binding private var selected: Bool

    public init(
        title: String,
        details: String? = nil,
        symbol: SFSymbol? = nil,
        selected: Binding<Bool>,
    ) {
        self.title = title
        self.details = details
        self.symbol = symbol
        self._selected = selected
    }

    public var body: some View {
        Button {
            selected.toggle()
        } label: {
            SettingsCard(interactive: true) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: Platform.spacing(.tightLine)) {
                        HStack(spacing: Platform.spacing(.xsmall)) {
                            if let symbol {
                                Image(symbol)
                                    .foregroundStyle(.secondary)
                            }
                            Text(title)
                        }
                        if let details {
                            Text(details)
                                .mosaicFont(.settingsFootnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer(minLength: 0)
                    Image(selected ? .checkmark_circle_fill : .circle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            .primary,
                            selected ? PaletteStore.shared.current.accentTint : .primary
                        )
                        .imageScale(.medium)
                        .padding(.trailing, 12)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
