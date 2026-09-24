//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A disclosure group that behaves like `DisclosureGroup` wherever that exists.
///
/// tvOS ships no `DisclosureGroup`, so there the label and contents render inline
/// (always expanded) instead of failing to compile. On macOS, iOS, and iPadOS it
/// is a plain `DisclosureGroup` pinned to an internal expanded state.
public struct PlatformDisclosureGroup<Label: View, Content: View>: View {

    private let content: Content
    private let label: Label
    private let expanded: Binding<Bool>?

    @State private var fallbackExpanded: Bool = false

    // MARK: - Initializers

    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.expanded = isExpanded
        self.content = content()
        self.label = label()
    }

    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.expanded = nil
        self.content = content()
        self.label = label()
    }

    public init(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) where Label == Text {
        self.expanded = nil
        self.content = content()
        self.label = Text(title)
    }

    // MARK: - Body

    public var body: some View {
        #if os(tvOS)
            VStack(alignment: .leading, spacing: Platform.spacing(.small)) {
                label
                content
            }
        #else
            DisclosureGroup(isExpanded: expanded ?? $fallbackExpanded) {
                content
            } label: {
                label
            }
        #endif
    }
}
