//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {
    func scrollsToTop() -> some View {
        #if os(iOS)
            modifier(ScrollsToTopModifier())
        #else
            self
        #endif
    }
}

#if os(iOS)

    @MainActor @Observable
    public final class ScrollToTopCoordinator {
        public var trigger: Int
        public init(trigger: Int = 0) { self.trigger = trigger }
        public func fire() { trigger += 1 }
    }

    public struct ScrollToTopCoordinatorKey: EnvironmentKey {
        public static let defaultValue: ScrollToTopCoordinator? = nil
    }

    public struct ScrollsToTopModifier: ViewModifier {
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
