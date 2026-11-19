//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// A list row that does something when tapped, without leaving the page.
    public struct SettingsListActionRow: View {

        // MARK: - Tone

        /// How the title reads. A destructive action is red, as in System
        /// Settings, so a row that removes something can't be mistaken for one
        /// that opens a page.
        public enum Tone: Sendable {
            case normal
            case destructive
        }

        // MARK: - Fields

        private let title: LocalizedStringKey
        private let detail: String?
        private let tone: Tone
        private let showsChevron: Bool
        private let action: () -> Void

        // MARK: - Initializer

        /// - Parameter showsChevron: The row opens something, even though it
        ///   isn't a navigation push (a sheet, a picker).
        public init(
            _ title: LocalizedStringKey,
            detail: String? = nil,
            tone: Tone = .normal,
            showsChevron: Bool = false,
            action: @escaping () -> Void,
        ) {
            self.title = title
            self.detail = detail
            self.tone = tone
            self.showsChevron = showsChevron
            self.action = action
        }

        /// For a name that isn't a localization key: a product, a license.
        public init(
            verbatim title: String,
            detail: String? = nil,
            tone: Tone = .normal,
            showsChevron: Bool = false,
            action: @escaping () -> Void,
        ) {
            self.init(
                LocalizedStringKey(title),
                detail: detail,
                tone: tone,
                showsChevron: showsChevron,
                action: action,
            )
        }

        // MARK: - Body

        public var body: some View {
            Button(action: action) {
                HStack(spacing: Platform.spacing(.small)) {
                    Text(title)
                        .foregroundStyle(titleColor)
                    Spacer(minLength: 12)
                    if let detail {
                        Text(detail)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    if showsChevron {
                        Image(.chevron_right)
                            .imageScale(.small)
                            .foregroundStyle(.tertiary)
                    }
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .listRowBackground(PaletteStore.shared.current.cardFill)
            .listRowSeparatorTint(PaletteStore.shared.current.cardBorder)
        }

        // MARK: - Helpers

        private var titleColor: Color {
            switch tone {
            case .normal: .primary
            case .destructive: PaletteStore.shared.current.errorLabel
            }
        }
    }

#endif
