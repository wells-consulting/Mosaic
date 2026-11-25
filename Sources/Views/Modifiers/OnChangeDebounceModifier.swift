//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting. All rights reserved.
//

import Foundation
import SwiftUI

public extension View {

    /// Runs `perform` after `value` stops changing for `delay` seconds.
    ///
    /// - Parameters:
    ///   - value: The value to watch.
    ///   - delay: The quiet period in seconds. Defaults to 0.5.
    ///   - action: The work to run with the settled value.
    func mosaicOnChangeDebounced<Value: Equatable>(
        of value: Value,
        delay: Double = 0.5,
        perform action: @escaping (Value) -> Void,
    ) -> some View {
        modifier(MosaicDebouncedChangeModifier(value: value, delay: delay, action: action))
    }
}

/// Watches a value and runs its action after the value settles.
public struct MosaicDebouncedChangeModifier<Value: Equatable>: ViewModifier {

    let value: Value
    let delay: Double
    let action: (Value) -> Void

    /// - Parameters:
    ///   - value: The value to watch.
    ///   - delay: The quiet period in seconds.
    ///   - action: The work to run with the settled value.
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
