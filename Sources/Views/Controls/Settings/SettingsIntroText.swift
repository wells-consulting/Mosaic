//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public struct SettingsIntroText: View {

    let text: LocalizedStringKey

    public init(verbatim text: String) {
        self.text = LocalizedStringKey(text)
    }

    public init(_ text: LocalizedStringKey) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .platformFont(.callout)
            .foregroundStyle(.secondary)
            .lineLimit(nil)
    }
}
