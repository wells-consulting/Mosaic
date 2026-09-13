//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public struct FormSection<Content: View>: View {

    // MARK: - Fields

    private let title: LocalizedStringKey
    private let content: Content

    // MARK: - Initializer

    public init(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: Platform.spacing(.settingsMenu)) {
            HStack(spacing: Platform.spacing(.small)) {
                VStack { Divider() }
                Text(title)
                    .platformFont(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize()
                VStack { Divider() }
            }
            .padding(.bottom, 4)
            content
        }
    }
}
