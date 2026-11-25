//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// A settings list row that opens another page. The list draws the chevron
    /// and the press highlight, so this is a plain `NavigationLink`.
    ///
    /// `Value` is whatever the host's navigation destination is registered for.
    public struct SettingsListLinkRow<Value: Hashable>: View {

        // MARK: - Fields

        private let title: LocalizedStringKey
        private let value: Value
        private let detail: String?

        // MARK: - Initializer

        /// - Parameters:
        ///   - title: The row's title.
        ///   - value: Where the row goes.
        ///   - detail: The row's current state, trailing ("Not connected").
        public init(_ title: LocalizedStringKey, value: Value, detail: String? = nil) {
            self.title = title
            self.value = value
            self.detail = detail
        }

        /// For a name that isn't a localization key: a server type, a person.
        ///
        /// - Parameters:
        ///   - title: The row's title, as written.
        ///   - value: Where the row goes.
        ///   - detail: The row's current state, trailing.
        public init(verbatim title: String, value: Value, detail: String? = nil) {
            self.title = LocalizedStringKey(title)
            self.value = value
            self.detail = detail
        }

        // MARK: - Body

        public var body: some View {
            NavigationLink(value: value) {
                HStack(spacing: Platform.spacing(.small)) {
                    Text(title)
                    Spacer(minLength: 12)
                    if let detail {
                        Text(detail)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .listRowBackground(PaletteStore.shared.current.cardFill)
            .listRowSeparatorTint(PaletteStore.shared.current.cardBorder)
        }
    }

#endif
