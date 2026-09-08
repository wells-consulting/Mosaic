//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

#if os(iOS)
    import UIKit
#endif

// MARK: - Injection

public extension View {

    /// Injects a computed `AppLayout` value into the environment based on device idiom
    /// and rendered geometry. Apply once at the app root so all descendant views can read
    /// `@Environment(\.appLayout)` without touching raw size class values.
    func injectDeviceLayoutEnvironment() -> some View {
        #if os(iOS)
            modifier(DeviceLayoutEnvironmentModifier())
        #else
            self
        #endif
    }
}

#if os(iOS)
    private struct DeviceLayoutEnvironmentModifier: ViewModifier {

        @Environment(\.horizontalSizeClass) private var hSizeClass

        // Initialised false (wide); onGeometryChange corrects this on first layout.
        @State private var isTall = false

        private var layout: DeviceLayout {
            if UIDevice.current.userInterfaceIdiom == .phone {
                isTall ? .phoneTall : .phoneWide
            } else if hSizeClass == .compact {
                .padCompact
            } else {
                isTall ? .padTall : .padWide
            }
        }

        func body(content: Content) -> some View {
            content
                .environment(\.layout, layout)
                .onGeometryChange(for: Bool.self) { geo in
                    geo.size.height > geo.size.width
                } action: { newValue in
                    isTall = newValue
                }
        }
    }
#endif
