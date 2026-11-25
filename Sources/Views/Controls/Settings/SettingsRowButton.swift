//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

/// A settings row drawn as a button: an icon, a title, an optional synopsis,
/// a badge, a value and a status.
public struct SettingsRowButton: View {

    // MARK: - Status

    /// What the row says about itself, after the title.
    public enum Status: Sendable {

        /// An ordinary detail, in secondary.
        case detail(String)

        /// The row's own state, in primary.
        case normal(String)

        /// Something that needs attention, in the warning color.
        case warning(String)

        var text: String {
            switch self {
            case let .detail(text), let .normal(text), let .warning(text):
                text
            }
        }
    }

    /// How much room a row takes.
    public enum Density: Sendable {

        /// The height a row has always been, on the floor the platform's own
        /// settings rows use.
        case regular

        /// No floor, and an inset around the label so a flat row reads like a
        /// list row rather than a button. The whole label is tappable.
        case compact
    }

    /// Row detail text that adapts to the horizontal size class on iOS.
    public enum AdaptiveText {

        /// One string at every width.
        case fixed(String?)

        /// Two strings, choosing the abbreviated one when room is tight.
        case adjustable(full: String?, abbreviated: String?)

        var text: String? {
            switch self {
            case let .fixed(string): string
            case let .adjustable(string, _): string
            }
        }

        #if os(iOS)
            func text(for sizeClass: UserInterfaceSizeClass?) -> String? {
                switch self {
                case let .fixed(string): string
                case let .adjustable(long, short):
                    sizeClass == .compact ? long : short
                }
            }
        #endif
    }

    // MARK: - Environment

    #if os(iOS)
        @Environment(\.verticalSizeClass) private var vSizeClass
    #endif

    @Environment(\.containerLayout) private var containerLayout
    @Environment(\.layout) private var layout
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Fields

    private let symbol: SFSymbol?
    private let text: LocalizedStringKey
    private let synopsis: String?
    private let badge: AdaptiveText?
    private let chevron: Bool
    private let value: AdaptiveText?
    private let status: Status?
    private let density: Density
    private let alignment: Alignment
    private let keepsSymbol: Bool
    private let action: () -> Void

    // MARK: - Initializers

    /// - Parameters:
    ///   - text: The row's title.
    ///   - symbol: An icon before the title.
    ///   - synopsis: A second line under the title.
    ///   - badge: A short value beside the title.
    ///   - value: The row's current value, trailing.
    ///   - status: A detail, a state or a warning after the title.
    ///   - chevron: Whether to show a trailing chevron.
    ///   - density: How much room the row takes.
    ///   - alignment: How the label sits in the row.
    ///   - keepsSymbol: Keep the icon on a narrow screen, where it would
    ///     otherwise be dropped.
    ///   - action: What the row runs when tapped.
    public init(
        _ text: LocalizedStringKey,
        symbol: SFSymbol? = nil,
        synopsis: String? = nil,
        badge: AdaptiveText? = nil,
        value: AdaptiveText? = nil,
        status: Status? = nil,
        chevron: Bool = true,
        density: Density = .regular,
        alignment: Alignment = .center,
        keepsSymbol: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.symbol = symbol
        self.synopsis = synopsis
        self.badge = badge
        self.chevron = chevron
        self.value = value
        self.status = status
        self.density = density
        self.alignment = alignment
        self.keepsSymbol = keepsSymbol
        self.action = action
    }

    /// - Parameters:
    ///   - label: The row's title, as written.
    ///   - symbol: An icon before the title.
    ///   - synopsis: A second line under the title.
    ///   - badge: A short value beside the title.
    ///   - value: The row's current value, trailing.
    ///   - status: A detail, a state or a warning after the title.
    ///   - chevron: Whether to show a trailing chevron.
    ///   - density: How much room the row takes.
    ///   - alignment: How the label sits in the row.
    ///   - keepsSymbol: Keep the icon on a narrow screen, where it would
    ///     otherwise be dropped.
    ///   - action: What the row runs when tapped.
    public init(
        verbatim label: String,
        symbol: SFSymbol? = nil,
        synopsis: String? = nil,
        badge: AdaptiveText? = nil,
        value: AdaptiveText? = nil,
        status: Status? = nil,
        chevron: Bool = true,
        density: Density = .regular,
        alignment: Alignment = .center,
        keepsSymbol: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(
            LocalizedStringKey(label),
            symbol: symbol,
            synopsis: synopsis,
            badge: badge,
            value: value,
            status: status,
            chevron: chevron,
            density: density,
            alignment: alignment,
            keepsSymbol: keepsSymbol,
            action: action
        )
    }

    /// The icon is a nice-to-have, and on a narrow screen (iPhone portrait, a
    /// narrow iPad split view) the room is worth more to the title and value.
    /// `keepsSymbol` is for a row whose icon matters.
    private var shownSymbol: SFSymbol? {
        layout.widthConstrained && !keepsSymbol ? nil : symbol
    }

    // MARK: - Body

    public var body: some View {
        Button {
            action()
        } label: {
            if density == .compact {
                label
                    .padding(8)
                    .contentShape(.rect)
            } else {
                label
            }
        }
        .frame(minHeight: density == .compact ? 0 : Self.minRowHeight)
    }

    @ViewBuilder
    private var label: some View {
        if let status {
            statusLabel(status)
        } else {
            plainLabel
        }
    }

    /// The row as it has always looked: one line, with the detail trailing.
    private var plainLabel: some View {
        SymbolLabel(
            text,
            symbol: shownSymbol,
            tint: .palette(.secondary, .secondary.opacity(0.75)),
            details: detailString,
            badge: badgeString,
            addChevron: chevron,
        )
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    /// A row with a status: the status sits beside the words, or under them
    /// when there isn't room for both it and a synopsis.
    private func statusLabel(_ status: Status) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                titleView
                if let synopsis {
                    Text(synopsis)
                        .foregroundStyle(.secondary)
                }
                if stacksStatus {
                    statusText(status)
                }
            }
            Spacer(minLength: 8)
            if !stacksStatus {
                statusText(status)
            }
            if chevron {
                Chevron()
            }
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    // MARK: - Pieces

    @ViewBuilder
    private var titleView: some View {
        if let symbol = shownSymbol {
            Label(text, symbol: symbol)
        } else {
            Text(text)
        }
    }

    private func statusText(_ status: Status) -> some View {
        Text(status.text)
            .foregroundStyle(statusColor(status))
            .lineLimit(stacksStatus ? 2 : 1)
    }

    private func statusColor(_ status: Status) -> Color {
        switch status {
        case .detail:
            .secondary
        case .normal:
            .primary
        case .warning:
            PaletteStore.shared.current.warningLabel
        }
    }

    /// True on a phone's width when there's a synopsis, and at any width at an
    /// accessibility text size, because beside the words the status would
    /// truncate. A compact row with no synopsis keeps it on the title line.
    private var stacksStatus: Bool {
        dynamicTypeSize.isAccessibilitySize
            || (containerLayout.widthClass == .compact && synopsis != nil)
    }

    // MARK: - Detail

    private var detailString: String? {
        #if os(iOS)
            value?.text(for: vSizeClass)
        #else
            value?.text
        #endif
    }

    private var badgeString: String? {
        #if os(iOS)
            badge?.text(for: vSizeClass)
        #else
            badge?.text
        #endif
    }

    /// HIG floors: a touch-sized 44pt on iOS, 66pt under the tvOS focus
    /// engine, and macOS's pointer-driven floor — the same heights the capsule
    /// button style already enforces, so flat rows and raised buttons stay
    /// consistent. Native chrome packs macOS rows to System Settings' ~32pt
    /// density; custom chrome keeps the taller capsule floor.
    @MainActor
    private static var minRowHeight: CGFloat {
        #if os(iOS)
            44
        #elseif os(macOS)
            44
        #elseif os(tvOS)
            66
        #endif
    }
}

#Preview {
    VStack {
        SettingsRowButton(
            "Review Setup",
            symbol: .wrench_and_screwdriver_fill,
            chevron: true,
            action: {}
        )
        SettingsRowButton(
            "Energy History",
            symbol: .clock,
            synopsis: "A year of hourly readings from the gateway.",
            status: .warning("Incomplete"),
            action: {}
        )
        .buttonStyle(.mosaic())
        .padding()
        .preferredColorScheme(.dark)
    }
}
