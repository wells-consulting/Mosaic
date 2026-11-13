//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// Gives its content the `ContainerLayout` from the nearest
/// `.mosaicMeasuresContainerLayout()` above.
///
/// A view that installs the modifier in its body can't read the result from the
/// environment, so it reads it here instead.
public struct ContainerLayoutReader<Content: View>: View {

    @Environment(\.containerLayout) private var containerLayout

    @ViewBuilder private let content: (ContainerLayout) -> Content

    public init(@ViewBuilder content: @escaping (ContainerLayout) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(containerLayout)
    }
}
