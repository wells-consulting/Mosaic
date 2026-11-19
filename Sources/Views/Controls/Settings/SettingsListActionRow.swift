//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// A list row that does something when tapped, without leaving the page.
    public struct SettingsListActionRow: View {

        // MARK: - Tone

        /// How the title reads. Prominent is the accent color, for the one
        /// action a page exists to run. There's no red tone: the apps don't put
        /// warning colors on text, and the confirmation dialog is what stops a
        /// destructive action anyway.
        public enum Tone: Sendable {
            case normal
            case prominent
        }

        // MARK: - Fields

        private let title: LocalizedStringKey
        private let detail: String?
        private let tone: Tone
        private let isSelected: Bool
        private let showsChevron: Bool
        private let action: () -> Void

        // MARK: - Initializer

        /// - Parameters:
        ///   - isSelected: On a page where the row picks one of a list, the
        ///     current pick, with a checkmark trailing.
        ///   - showsChevron: The row opens something, even though it isn't a
        ///     navigation push (a sheet, a picker).
        public init(
            _ title: LocalizedStringKey,
            detail: String? = nil,
            tone: Tone = .normal,
            isSelected: Bool = false,
            showsChevron: Bool = false,
            action: @escaping () -> Void,
        ) {
            self.title = title
            self.detail = detail
            self.tone = tone
            self.isSelected = isSelected
            self.showsChevron = showsChevron
            self.action = action
        }

        /// For a name that isn't a localization key: a product, a license.
        public init(
            verbatim title: String,
            detail: String? = nil,
            tone: Tone = .normal,
            isSelected: Bool = false,
            showsChevron: Bool = false,
            action: @escaping () -> Void,
        ) {
            self.init(
                LocalizedStringKey(title),
                detail: detail,
                tone: tone,
                isSelected: isSelected,
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
                    if isSelected {
                        Image(.checkmark)
                            .foregroundStyle(PaletteStore.shared.current.accentLabel)
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
            case .prominent: PaletteStore.shared.current.accentLabel
            }
        }
    }

#endif
