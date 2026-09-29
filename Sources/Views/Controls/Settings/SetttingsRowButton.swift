//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public struct SettingsRowButton: View {

    #if os(iOS)
        @Environment(\.verticalSizeClass) private var vSizeClass
    #endif

    /// Row detail text that adapts to the horizontal size class on iOS.
    public enum AdaptiveText {
        case fixed(String?)
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

    private let symbol: SFSymbol
    private let text: LocalizedStringKey
    private let badge: AdaptiveText?
    private let chevron: Bool
    private let value: AdaptiveText?
    private let alignment: Alignment
    private let action: () -> Void

    public init(
        _ text: LocalizedStringKey,
        symbol: SFSymbol,
        badge: AdaptiveText? = nil,
        value: AdaptiveText? = nil,
        chevron: Bool = true,
        alignment: Alignment = .center,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.symbol = symbol
        self.badge = badge
        self.chevron = chevron
        self.value = value
        self.alignment = alignment
        self.action = action
    }

    public init(
        verbatim label: String,
        symbol: SFSymbol,
        badge: AdaptiveText? = nil,
        value: AdaptiveText? = nil,
        chevron: Bool = true,
        action: @escaping () -> Void
    ) {
        self.init(
            LocalizedStringKey(label),
            symbol: symbol,
            badge: badge,
            value: value,
            chevron: chevron,
            action: action
        )
    }

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

    public var body: some View {
        Button {
            action()
        } label: {
            SymbolLabel(
                text,
                symbol: symbol,
                symbolPalette: (.secondary, .secondary.opacity(0.75)),
                details: detailString,
                badge: badgeString,
                addChevron: chevron,
            )
            .frame(maxWidth: .infinity, alignment: alignment)
        }
        // A settings row is flat content inside its card on iOS/macOS — the iOS
        // InsetGrouped look. tvOS alone keeps the prominent capsule (and its
        // white-on-focus inversion) as the focus-engine navigation chrome.
        #if os(tvOS)
            .mosaicButtonStyle(.neutral(.prominent))
        #elseif os(iOS)
            .buttonStyle(.plain)
        #elseif os(macOS)
            .buttonStyle(.plain)
        #endif
        .frame(minHeight: Self.minRowHeight)
    }

    // HIG floors: a touch-sized 44pt on iOS, 66pt under the tvOS focus
    // engine, and macOS's pointer-driven floor — the same heights the capsule
    // button style already enforces, so flat rows and raised buttons stay
    // consistent. Native chrome packs macOS rows to System Settings' ~32pt
    // density; custom chrome keeps the taller capsule floor.
    @MainActor
    private static var minRowHeight: CGFloat {
        #if os(iOS)
            44
        #elseif os(macOS)
            44
        #else
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
        .padding()
    }
}
