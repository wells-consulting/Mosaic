//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public struct SettingsSectionLabel: View {

    private let label: Text

    public init(_ title: LocalizedStringKey) {
        self.label = Text(title)
    }

    public init(verbatim title: String) {
        self.label = Text(verbatim: title)
    }

    public var body: some View {
        HStack(spacing: 0) {
            label
                .platformFont(.caption)
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
