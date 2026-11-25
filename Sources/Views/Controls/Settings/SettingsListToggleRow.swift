//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// An on/off setting as a list row with the system switch.
    public struct SettingsListToggleRow: View {

        // MARK: - Fields

        private let title: LocalizedStringKey
        private let note: String?
        @Binding private var isOn: Bool

        // MARK: - Initializer

        /// - Parameters:
        ///   - title: The row's title.
        ///   - isOn: Whether the switch is on.
        ///   - note: A second line under the title, for the reason the switch
        ///     can't move ("Turn off App Lock to change this.").
        public init(_ title: LocalizedStringKey, isOn: Binding<Bool>, note: String? = nil) {
            self.title = title
            self.note = note
            self._isOn = isOn
        }

        // MARK: - Body

        public var body: some View {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    if let note {
                        Text(note)
                            .mosaicFont(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listRowBackground(PaletteStore.shared.current.cardFill)
            .listRowSeparatorTint(PaletteStore.shared.current.cardBorder)
        }
    }

#endif
