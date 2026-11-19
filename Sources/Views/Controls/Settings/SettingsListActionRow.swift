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
        private let action: () -> Void

        // MARK: - Initializer

        public init(
            _ title: LocalizedStringKey,
            detail: String? = nil,
            tone: Tone = .normal,
            action: @escaping () -> Void,
        ) {
            self.title = title
            self.detail = detail
            self.tone = tone
            self.action = action
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
