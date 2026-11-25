//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A titled group of form fields, separated from the next section by a pair of
/// hairlines.
public struct FormSection<Content: View>: View {

    // MARK: - Fields

    private let title: LocalizedStringKey
    private let content: Content

    // MARK: - Initializer

    /// - Parameters:
    ///   - title: The section heading.
    ///   - content: The fields in the section.
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
                    .mosaicFont(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize()
                VStack { Divider() }
            }
            .padding(.bottom, 4)
            content
        }
    }
}
