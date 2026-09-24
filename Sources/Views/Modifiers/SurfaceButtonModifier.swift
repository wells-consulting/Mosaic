//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Applies `.buttonStyle(.glass(.clear))` on iOS where toolbar and inline buttons
    /// need an explicit bordered appearance. No-op on tvOS where the default
    /// styles are already appropriate.
    ///
    /// Uses `.large` control size (~50pt) on all iOS form factors so standalone
    /// button pills carry the same internal padding as `appGlassMenuContent()` menus.
    func mosaicSurfaceButtonStyle() -> some View {
        #if os(iOS)
            modifier(MosaicAdaptiveButtonStyleModifier())
        #else
            self
        #endif
    }
}

#if os(iOS)
    private struct MosaicAdaptiveButtonStyleModifier: ViewModifier {

        @Environment(\.insideButtonGroup) private var insideButtonGroup

        func body(content: Content) -> some View {
            if insideButtonGroup {
                // Parent `GlassButtonGroup` provides the shared pill — render the button
                // borderless so we don't get nested glass layers. No explicit control
                // size: a borderless button sized to its label gives the pill a uniform
                // height regardless of whether children are `Button`s or `Menu`s. iOS
                // automatically extends the hit area to the 44pt accessibility minimum.
                content
                    .buttonStyle(.borderless)
            } else {
                // Standalone button: use explicit padding matching `AppAdaptiveMenuStyleModifier`
                // so buttons and menus render at identical sizes. `.glass().controlSize(.large)`
                // adds more horizontal padding than the 16pt used by `appGlassMenuContent()`,
                // so we apply the glass effect directly with the same insets as the menu path.
                content
                    .buttonStyle(MosaicStandaloneSurfaceButtonStyle())
            }
        }
    }

    private struct MosaicStandaloneSurfaceButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.vertical, 16)
                .padding(.horizontal)
                .frame(minHeight: 22)
                .glassEffect(
                    .regular.tint(.white.opacity(0.08)).interactive(),
                    in: Capsule()
                )
        }
    }
#endif
