//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// The standard iOS settings list: inset cards of rows, section headers,
    /// and separators that start where the text does.
    ///
    /// `SettingsPage` draws every row as a pill, which is right on tvOS where a
    /// row is a focusable button. On iOS a pill can't hold a picker without
    /// looking like two different things, so this holds rows instead: a row is
    /// a row, and the control lives inside it.
    ///
    /// ```swift
    /// SettingsList {
    ///     Section("Video") {
    ///         SettingsListToggleRow("Include Previews", isOn: $includePreviews)
    ///         SettingsListChoiceRow("Quality", options: qualities, selection: $quality)
    ///     }
    /// }
    /// ```
    public struct SettingsList<Content: View>: View {

        // MARK: - Fields

        private let content: Content

        // MARK: - Initializer

        /// - Parameter content: The list's sections and rows.
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        // MARK: - Body

        public var body: some View {
            List {
                content
            }
            .listStyle(.insetGrouped)
            // The page draws the background; a list background would cover it
            .scrollContentBackground(.hidden)
            .environment(\.defaultMinListRowHeight, 44)
            // Hosts may have applied a custom button style to the page. Inside
            // a list the row is the button, so go back to the platform default.
            .buttonStyle(.automatic)
            .tint(PaletteStore.shared.current.accentLabel)
            // Insetting the content, not framing the list, keeps the scroll
            // edge effect under the navigation bar full width
            .modifier(SettingsColumnModifier())
        }
    }

#endif
