//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// An intro paragraph for the top of a settings page.
public struct SettingsIntroText: View {

    let text: LocalizedStringKey

    /// - Parameter text: The paragraph, as written.
    public init(verbatim text: String) {
        self.text = LocalizedStringKey(text)
    }

    /// - Parameter text: The paragraph.
    public init(_ text: LocalizedStringKey) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .mosaicFont(.settingsIntro)
            .foregroundStyle(.secondary)
            .lineLimit(nil)
    }
}
