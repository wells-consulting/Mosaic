//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// A setting with a handful of choices, as one list row: the title, then
    /// the choices as a segmented control under it.
    ///
    /// This is the shape System Settings gives its Appearance row. The
    /// alternative — a row that opens its choices where it sits — reads as a
    /// drop-down menu, which iOS settings don't have.
    ///
    /// Keep `label` to a word or two: a segment truncates faster than a row.
    public struct SettingsListChoiceRow<Value: Hashable>: View {

        // MARK: - Fields

        private let title: LocalizedStringKey
        private let options: [Value]
        private let label: (Value) -> String
        private let reason: String?
        @Binding private var selection: Value

        // MARK: - Initializer

        /// - Parameters:
        ///   - label: The choice on its segment ("Off", "Once", "Loop").
        ///   - reason: Why the row can't be changed, trailing on the title line
        ///     ("Offline").
        public init(
            _ title: LocalizedStringKey,
            options: [Value],
            selection: Binding<Value>,
            label: @escaping (Value) -> String,
            reason: String? = nil,
        ) {
            self.title = title
            self.options = options
            self._selection = selection
            self.label = label
            self.reason = reason
        }

        // MARK: - Body

        public var body: some View {
            VStack(alignment: .leading, spacing: Platform.spacing(.small)) {
                HStack(spacing: Platform.spacing(.small)) {
                    Text(title)
                    Spacer(minLength: 12)
                    if let reason {
                        Text(reason)
                            .foregroundStyle(.secondary)
                    }
                }
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(label(option)).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .listRowBackground(PaletteStore.shared.current.cardFill)
            .listRowSeparatorTint(PaletteStore.shared.current.cardBorder)
        }
    }

#endif
