//
// the app – Your Stash, beautifuly rendered
// Copyright 2025-2026 Wells Consulting. All rights reserved.
//

import Foundation
import SwiftUI

public extension View {

    func mosaicOnChangeDebounced<Value: Equatable>(
        of value: Value,
        delay: Double = 0.5,
        perform action: @escaping (Value) -> Void,
    ) -> some View {
        modifier(MosaicDebouncedChangeModifier(value: value, delay: delay, action: action))
    }
}

public struct MosaicDebouncedChangeModifier<Value: Equatable>: ViewModifier {

    let value: Value
    let delay: Double
    let action: (Value) -> Void

    public init(
        value: Value,
        delay: Double,
        action: @escaping (Value) -> Void
    ) {
        self.value = value
        self.delay = delay
        self.action = action
    }

    @State private var debounceTask: Task<Void, Never>?

    public func body(content: Content) -> some View {
        content
            .onChange(of: value) { _, newValue in
                debounceTask?.cancel()
                debounceTask = Task {
                    // swiftlint:disable:next no_try_question
                    try? await Task.sleep(for: .seconds(delay))
                    guard !Task.isCancelled else { return }
                    action(newValue)
                }
            }
    }
}
