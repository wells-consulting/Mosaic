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
/// SettingsSection("Cache") {
///     clearImageCacheButton
///     rebuildSearchIndexButton
/// }
/// ```
///
/// The page supplies the gap between sections, so the first section needs
/// nothing special.
public struct SettingsSection<Content: View>: View {

    // MARK: - Fields

    private let title: LocalizedStringKey?
    private let verbatimTitle: String?
    private let content: Content

    // MARK: - Initializer

    /// A section with no heading.
    public init(@ViewBuilder content: () -> Content) {
        self.title = nil
        self.verbatimTitle = nil
        self.content = content()
    }

    /// - Parameters:
    ///   - title: The section heading.
    ///   - content: The rows in the section.
    public init(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.verbatimTitle = nil
        self.content = content()
    }

    /// - Parameters:
    ///   - title: The section heading, as written.
    ///   - content: The rows in the section.
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
                    .mosaicPadding(.bottom, .settingsSectionBottom)
            } else if let verbatimTitle {
                SettingsSectionLabel(verbatim: verbatimTitle)
                    .mosaicPadding(.bottom, .settingsSectionBottom)
            }
            #if os(macOS)
                List {
                    content
                }
                .listStyle(.sidebar)
                .listRowSeparator(.automatic)
            #else
                content
            #endif
        }
    }
}

#if DEBUG
    #Preview("Native") {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSection("Section Title") {
                SettingsMenu {
                    SettingsRowButton("Home", symbol: .house) {}
                    SettingsRowButton("Maintenance", symbol: .wrench_and_screwdriver) {}
                }
            }
            .buttonStyle(.mosaic(.neutral(.prominent)))
            .mosaicSettingsContentInsetPadding()
        }
        .padding(32)
        .preferredColorScheme(.dark)
    }
#endif
