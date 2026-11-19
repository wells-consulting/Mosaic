//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(iOS)

    import SwiftUI

    /// A setting with a handful of choices, as one list row.
    ///
    /// Closed, the row reads like every other row: title on the left, current
    /// choice trailing. Tapping it opens the choices inside the row rather than
    /// behind a menu, because a menu would be the only row on the page that
    /// behaves that way.
    public struct SettingsListChoiceRow<Value: Hashable>: View {

        // MARK: - Fields

        private let title: LocalizedStringKey
        private let options: [Value]
        private let label: (Value) -> String
        private let fullLabel: (Value) -> String
        private let reason: String?
        @Binding private var selection: Value

        // MARK: - State

        @State private var isExpanded = false

        // MARK: - Initializer

        /// - Parameters:
        ///   - label: The choice in the closed row. A word or two.
        ///   - fullLabel: The choice in the open list, where there's room for
        ///     a whole phrase ("Countdown before next").
        ///   - reason: Why the row can't be changed, trailing instead of the
        ///     choice ("Offline").
        public init(
            _ title: LocalizedStringKey,
            options: [Value],
            selection: Binding<Value>,
            label: @escaping (Value) -> String,
            fullLabel: @escaping (Value) -> String,
            reason: String? = nil,
        ) {
            self.title = title
            self.options = options
            self._selection = selection
            self.label = label
            self.fullLabel = fullLabel
            self.reason = reason
        }

        // MARK: - Body

        public var body: some View {
            VStack(spacing: 0) {
                closedRow
                if isExpanded {
                    choices
                }
            }
            .listRowBackground(PaletteStore.shared.current.cardFill)
            .listRowSeparatorTint(PaletteStore.shared.current.cardBorder)
        }

        // MARK: - Subviews

        private var closedRow: some View {
            Button {
                withAnimation(.snappy) { isExpanded.toggle() }
            } label: {
                HStack(spacing: Platform.spacing(.small)) {
                    Text(title)
                    Spacer(minLength: 12)
                    Text(reason ?? label(selection))
                        .foregroundStyle(.secondary)
                    // A row that can't open has nothing to say the chevron for
                    if reason == nil {
                        Image(.chevron_down)
                            .imageScale(.small)
                            .foregroundStyle(.tertiary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .frame(minHeight: 22)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
        }

        private var choices: some View {
            VStack(spacing: 0) {
                Divider()
                ForEach(options, id: \.self) { option in
                    Button {
                        withAnimation(.snappy) {
                            selection = option
                            isExpanded = false
                        }
                    } label: {
                        HStack {
                            Text(fullLabel(option))
                            Spacer()
                            if option == selection {
                                Image(.checkmark)
                                    .foregroundStyle(PaletteStore.shared.current.accentLabel)
                            }
                        }
                        .frame(minHeight: 40)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

#endif
