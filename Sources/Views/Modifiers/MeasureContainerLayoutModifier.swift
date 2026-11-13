//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

// MARK: - Injection

public extension View {

    /// Measures this container and gives the `ContainerLayout` to everything
    /// below it, through `@Environment(\.containerLayout)`.
    ///
    /// Put it on a container root, not a leaf. A view that installs it can't
    /// read the result from the environment; use `ContainerLayoutReader`.
    func mosaicMeasuresContainerLayout() -> some View {
        modifier(MosaicContainerLayoutModifier())
    }
}

// MARK: - Modifier

private struct MosaicContainerLayoutModifier: ViewModifier {

    #if !os(watchOS)
        @Environment(\.verticalSizeClass) private var verticalSizeClass
    #endif

    @State private var size: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { measured in
                size = measured
            }
            .environment(\.containerLayout, layout)
    }

    private var layout: ContainerLayout {
        ContainerLayout(
            width: size.width > 0 ? size.width : ContainerLayout.fallback.width,
            height: size.height,
            heightClass: heightClass,
            hasPointer: Self.hasPointer,
            isTelevision: Self.isTelevision,
        )
    }

    /// The watch has no vertical size class, and its screen is always tall.
    private var heightClass: ContainerLayout.HeightClass {
        #if os(watchOS)
            .regular
        #else
            verticalSizeClass == .compact ? .compact : .regular
        #endif
    }

    /// A Mac always has a pointer. An iPad's trackpad can't be seen from here,
    /// so pointer-only affordances stay on the Mac.
    private static var hasPointer: Bool {
        #if os(macOS)
            true
        #else
            false
        #endif
    }

    private static var isTelevision: Bool {
        #if os(tvOS)
            true
        #else
            false
        #endif
    }
}
