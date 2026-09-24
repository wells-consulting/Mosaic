//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

public extension View {
    func mosaicScrollsToTop() -> some View {
        #if os(iOS)
            modifier(MosaicScrollsToTopModifier())
        #else
            self
        #endif
    }
}

#if os(iOS)

    @MainActor @Observable
    public final class MosaicScrollToTopCoordinator {
        public var trigger: Int
        public init(trigger: Int = 0) { self.trigger = trigger }
        public func fire() { trigger += 1 }
    }

    public struct MosaicScrollToTopCoordinatorKey: EnvironmentKey {
        public static let defaultValue: MosaicScrollToTopCoordinator? = nil
    }

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
