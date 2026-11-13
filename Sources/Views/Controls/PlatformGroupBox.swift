//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A titled `GroupBox`, with the television's fallback and the macOS focus
/// halo fixed.
///
/// The group is one list row. On macOS the row that pushed here regains focus
/// on pop and paints an accent halo over the whole group, which shows on the
/// row background, so the background is cleared and the focus effect turned
/// off.
public struct PlatformGroupBox<Content: View>: View {

    private let title: LocalizedStringKey?
    private let content: Content

    public init(
        _ title: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content,
    ) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title).font(.headline)
            }

            #if os(tvOS)
                // No `GroupBox` on the television.
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .backgroundStyle(PaletteStore.shared.current.rowBackground)
            #else
                GroupBox {
                    content
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .backgroundStyle(PaletteStore.shared.current.rowBackground)
            #endif
        }
        .mosaicListRowSeparator()
        .listRowBackground(Color.clear)
        .focusEffectDisabled()
    }
}
