//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    func formButtonStyle(
        _ appearance: ButtonAppearance = .neutral(.regular),
    ) -> some View {
        buttonStyle(
            FormButtonStyle(appearance: appearance)
        )
    }
}

// MARK: - Neutral surface

/// Tiled grain overlay standing in for the "linen/paper" texture system
/// Glass doesn't provide. `grain-tile.png` is 128×128 px, per-pixel
/// noise centered on mid-gray (127 mean, ~22 std, generated once and
/// bundled as an asset — not procedural, so there's no runtime cost and
/// no risk of the tile not repeating seamlessly, which per-pixel noise
/// does by construction since it has no macro structure to mismatch at
/// the tile edge). Blended with `.overlay`, which treats mid-gray (127)
/// as the no-op point: lighter noise pixels lighten what's under them,
/// darker pixels darken it, symmetric around zero effect.
private struct GrainOverlay: View {
    var opacity: Double

    var body: some View {
        Rectangle()
            .fill(ImagePaint(image: Image("grain-tile", bundle: .module), scale: 1))
            .blendMode(.overlay)
            .opacity(opacity)
            .allowsHitTesting(false)
    }
}

/// The `.neutral` role's background: gradient + grain + edge highlight
/// + shadow, entirely hand-built rather than system Glass.
///
/// Respects Reduce Transparency itself, since opting out of Glass means
/// opting out of the automatic handling Glass gives you for free.
/// `.overlay`/`.softLight` blending is exactly the kind of blended
/// translucent effect that setting exists to reduce, so it's dropped
/// (not just dimmed) when the preference is on — matching what Glass
/// would have done automatically had we kept using it.
private struct NeutralCapsuleBackground: View {

    var prominence: ButtonAppearance.Prominence
    #if os(tvOS)
        // When focused on tvOS the button inverts to a white fill (dark → light).
        var isFocused: Bool = false
    #endif

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        #if os(tvOS)
            if isFocused {
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.35), radius: 14, y: 7)
            } else {
                darkGradient
            }
        #else
            darkGradient
        #endif
    }

    @ViewBuilder
    private var darkGradient: some View {
        let palette = PaletteStore.shared.palette
        let (top, bottom): (Color, Color) =
            prominence == .prominent
            ? (palette.neutralProminentTop, palette.neutralProminentBottom)
            : (palette.neutralRegularTop, palette.neutralRegularBottom)
        let grainOpacity = prominence == .prominent ? 0.13 : 0.07
        let highlightOpacity = prominence == .prominent ? 0.20 : 0.18

        ZStack {
            LinearGradient(colors: [top, bottom], startPoint: .top, endPoint: .bottom)
            if !reduceTransparency {
                GrainOverlay(opacity: grainOpacity)
            }
        }
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(highlightOpacity),
                            Color.white.opacity(0),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        // Tied to prominence rather than a fixed value: regular-tier
        // buttons are the ones that end up stacked close together, so
        // that's exactly where a soft, wide shadow bleeding into the
        // inter-button gap reads as "attached" rather than "separate." A
        // 6pt blur radius is comparable to a typical 14pt VStack spacing
        // — soft shadows fall off gradually, not at a hard edge, so
        // there's a real chance it was still visible most of the way
        // across that gap. Prominent keeps more lift, since it's
        // supposed to have more visual presence; regular gets pulled in
        // tighter.
        .shadow(
            color: .black.opacity(prominence == .prominent ? 0.26 : 0.08),
            radius: prominence == .prominent ? 5 : 1.5,
            x: 0,
            y: prominence == .prominent ? 3 : 0.5
        )
    }
}

// MARK: - ButtonStyle

/// Capsule-shaped button style parameterized by semantic role and (for
/// `.neutral`) prominence. Uses a `LinearGradient` fill so buttons have
/// visible texture and depth independent of what's behind them — on a
/// flat dark background, a glass material has nothing to blur and reads
/// as a flat opaque fill.
private struct FormButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused

    var appearance: ButtonAppearance

    func makeBody(configuration: Configuration) -> some View {

        // foregroundStyle is applied per-branch below rather than here, so that
        // the tvOS neutral case can switch to dark text on the white focused background.
        let labelBase = configuration.label
            .padding(.horizontal, 20)
            // HIG minimum tappable area is 44x44pt; this is a floor,
            // not a fixed height, so a Dynamic Type-scaled label can
            // still grow the button taller.
            #if os(iOS)
                .frame(minHeight: 44)
            #else
                .frame(minHeight: 66)
            #endif
            // Defensive: if a call site's label is an HStack containing a
            // Spacer (e.g. an icon-left/chevron-right row layout), the
            // Spacer draws no content, so without an explicit content
            // shape the tap-recognition region has a dead zone over it —
            // taps in the gap fall through instead of triggering the
            // button. Declaring the shape here, after the frame is
            // established, makes the *entire* laid-out capsule tappable
            // regardless of what the label's internal layout looks like.
            .contentShape(.rect)

        if case let .neutral(prominence) = appearance {
            #if os(tvOS)
                // Dark → light inversion on focus: white background + dark text.
                labelBase
                    .foregroundStyle(
                        isFocused
                            ? AnyShapeStyle(.black)
                            : AnyShapeStyle(appearance.labelColor(disabled: !isEnabled))
                    )
                    .background(
                        NeutralCapsuleBackground(prominence: prominence, isFocused: isFocused)
                    )
                    .opacity(configuration.isPressed ? 0.75 : 1.0)
                    .scaleEffect(isFocused ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                    .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            #else
                labelBase
                    .foregroundStyle(appearance.labelColor(disabled: !isEnabled))
                    .background(NeutralCapsuleBackground(prominence: prominence))
                    .opacity(configuration.isPressed ? 0.75 : 1.0)
                    .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            #endif
        } else {
            let color =
                if configuration.role == .destructive {
                    ButtonAppearance.destructive.fillColor  // Honor SwiftUI.ButtonRole
                } else {
                    appearance.fillColor
                }
            labelBase
                .foregroundStyle(appearance.labelColor(disabled: !isEnabled))
                .glassEffect(Glass.regular.tint(color).interactive(), in: Capsule())
                #if os(tvOS)
                    .cardFocus(hasFocus: isFocused, tvOS: .spotlight)
                #endif
        }
    }
}

// MARK: - Previews

#if DEBUG

    #Preview {
        VStack(spacing: 12) {
            Button("Neutral (Regular)") {}
                .formButtonStyle()
            Button("Neutral (Prominent)") {}
                .formButtonStyle(.neutral(.prominent))
            Button("Confirm") {}
                .formButtonStyle(.confirm)
            Button("Destructive") {}
                .formButtonStyle(.destructive)
            Button("Attention") {}
                .formButtonStyle(.tinted(PaletteStore.shared.palette.accentTint))
        }
        .padding(.horizontal, 40)
        .colorScheme(.dark)
        .frame(width: 500, height: 450)
        .vignetteBackground(PaletteStore.shared.palette.vignette)
    }

#endif
