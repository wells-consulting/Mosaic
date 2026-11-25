//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {

    /// Scrolls the view to the top when the environment's coordinator fires.
    /// No-op outside iOS.
    func mosaicScrollsToTop() -> some View {
        #if os(iOS)
            modifier(MosaicScrollsToTopModifier())
        #else
            self
        #endif
    }
}

#if os(iOS)

    /// Fires the signal that a view with `.mosaicScrollsToTop()` watches.
    @MainActor @Observable
    public final class MosaicScrollToTopCoordinator {

        /// Changes each time `fire()` runs.
        public var trigger: Int

        /// - Parameter trigger: The starting value.
        public init(trigger: Int = 0) { self.trigger = trigger }

        /// Asks every watching scroll view to go to the top.
        public func fire() { trigger += 1 }
    }

    /// The environment key for the scroll-to-top coordinator.
    public struct MosaicScrollToTopCoordinatorKey: EnvironmentKey {

        /// No coordinator until one is set.
        public static let defaultValue: MosaicScrollToTopCoordinator? = nil
    }

    /// Watches the coordinator and scrolls to the top when it fires.
    public struct MosaicScrollsToTopModifier: ViewModifier {
        @Environment(\.scrollToTopCoordinator) private var coordinator
        @State private var scrollPosition = ScrollPosition()
        public func body(content: Content) -> some View {
            content.scrollPosition($scrollPosition)
                .onChange(of: coordinator?.trigger) { _, _ in
                    withAnimation {
                        scrollPosition.scrollTo(edge: .top)
                    }
                }
        }
    }
#endif
