//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A styled card container for settings content.
///
/// Pass `interactive: true` when the card wraps a tappable row — it renders with a
/// Liquid Glass background on iOS. Pass `interactive: false` (the default) for display-only
/// content like data tables; it renders with the standard solid card fill on all platforms.
///
/// On tvOS the distinction has no effect — both variants use the solid fill.
///
/// ```swift
/// // Display container (plugins list, timing table, etc.)
/// SettingsCard {
///     ForEach(rows) { row in rowView(row) }
/// }
///
/// // Tappable row
/// SettingsCard(interactive: true) {
///     Button { ... } label: { ... }
///         .buttonStyle(.plain)
/// }
/// ```
public struct SettingsCard<Content: View>: View {

    // MARK: - Fields

    private let content: Content
    private let interactive: Bool

    // MARK: - Initializer

    public init(interactive: Bool = false, @ViewBuilder content: () -> Content) {
        self.interactive = interactive
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        #if os(tvOS)
            let cornerRadius = Platform.cornerRadius(.large)
        #else
            let cornerRadius = Platform.cornerRadius(.medium)
        #endif
        content
            .padding(.large)
            .modifier(SettingsCardBackground(cornerRadius: cornerRadius, interactive: interactive))
    }
}

// MARK: - Background modifier

private struct SettingsCardBackground: ViewModifier {

    let cornerRadius: CGFloat
    let interactive: Bool

    func body(content: Content) -> some View {
        #if os(iOS)
            if interactive {
                content
                    .glassEffect(
                        .regular.interactive(),
                        in: .rect(cornerRadius: cornerRadius, style: .continuous)
                    )
            } else {
                content
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(PaletteStore.shared.palette.cardFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(
                            PaletteStore.shared.palette.cardBorder,
                            lineWidth: 0.5
                        )
                    )
            }
        #else
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(PaletteStore.shared.palette.cardFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(
                        PaletteStore.shared.palette.cardBorder,
                        lineWidth: 0.5
                    )
                )
        #endif
    }
}
