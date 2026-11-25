//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A small uppercase heading above a group of settings rows.
public struct SettingsSectionLabel: View {

    private let label: Text

    /// - Parameter title: The heading text.
    public init(_ title: LocalizedStringKey) {
        self.label = Text(title)
    }

    /// - Parameter title: The heading text, as written.
    public init(verbatim title: String) {
        self.label = Text(verbatim: title)
    }

    public var body: some View {
        HStack(spacing: 0) {
            label
                .mosaicFont(.settingsFootnote)
                .textCase(.uppercase)
                .kerning(1.0)
                #if os(tvOS)
                    .foregroundStyle(.tertiary)  // audit: tvOS
                #else
                    .foregroundStyle(.primary)
                #endif
            Spacer(minLength: 0)
        }
    }
}
