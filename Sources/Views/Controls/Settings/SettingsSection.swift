//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A labeled group of settings rows.
///
/// Wraps a `SettingsSectionLabel` and its content rows in a `VStack` with consistent
/// spacing. Use this instead of writing `VStack { SettingsSectionLabel(...); row1; row2 }`
/// directly — it guarantees every section has the same visual rhythm.
///
/// ```swift
/// SettingsSection("Cache", isFirstSection: true) {
///     clearImageCacheButton
///     rebuildSearchIndexButton
/// }
/// ```
///
/// The first section on a page should pass `isFirstSection: true` to avoid
/// extra top spacing that separates subsequent sections from one another.
public struct SettingsSection<Content: View>: View {

    // MARK: - Fields

    private let title: LocalizedStringKey?
    private let verbatimTitle: String?
    private let content: Content

    // MARK: - Initializer

    public init(@ViewBuilder content: () -> Content) {
        self.title = nil
        self.verbatimTitle = nil
        self.content = content()
    }

    public init(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.verbatimTitle = nil
        self.content = content()
    }

    public init(verbatim title: String, @ViewBuilder content: () -> Content) {
        self.title = nil
        self.verbatimTitle = title
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: Platform.spacing(.settingsMenu)) {
            if let title {
                SettingsSectionLabel(title)
                    .padding(.bottom, .settingsSectionBottom)
            } else if let verbatimTitle {
                SettingsSectionLabel(verbatim: verbatimTitle)
                    .padding(.bottom, .settingsSectionBottom)
            }
            content
        }
    }
}
