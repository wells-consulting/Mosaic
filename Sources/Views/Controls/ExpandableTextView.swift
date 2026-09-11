//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// A text view that clamps to a maximum height and expands on demand.
///
/// Renders `text` at the given `font` size. If the natural height exceeds `clampedHeight`,
/// a "Show More" button appears below. Tapping it reveals the full text via a
/// full-screen ``ScrollableTextView`` (a sheet on macOS); a "Show Less" button collapses it
/// again. On tvOS the expansion is toggled via a focusable button.
public struct ExpandableTextView: View {

    let text: String
    let font: Font
    let navigationBackground: AnyShapeStyle?

    @State private var fullHeight: CGFloat = 0
    @State private var clampedHeight: CGFloat = 0
    @State private var truncated: Bool = false
    @State private var showFullText: Bool = false

    @FocusState private var hasFocus: Bool

    // MARK: - Initializer

    public init(_ text: String, font: Font, navigationBackground: AnyShapeStyle? = nil) {
        self.text = text
        self.font = font
        self.navigationBackground = navigationBackground
    }

    // MARK: - Body

    public var body: some View {
        textView
            .foregroundStyle(.secondary)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(key: ClampedHeightKey.self, value: geo.size.height)
                },
            )
            .overlay(
                Text(text)
                    .font(font)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(key: FullHeightKey.self, value: geo.size.height)
                        },
                    ),
                alignment: .topLeading,
            )
            .onPreferenceChange(FullHeightKey.self) { fullHeight = $0 }
            .onPreferenceChange(ClampedHeightKey.self) { clampedHeight = $0 }
            .onChange(of: fullHeight) { _, _ in updateTruncation() }
            .onChange(of: clampedHeight) { _, _ in updateTruncation() }
            #if os(macOS)
                .sheet(isPresented: $showFullText) {
                    ScrollableTextView(text: text, navigationBackground: navigationBackground)
                        .frame(minWidth: 400, idealWidth: 480, minHeight: 300, idealHeight: 420)
                }
            #else
                .fullScreenCover(isPresented: $showFullText) {
                    ScrollableTextView(text: text, navigationBackground: navigationBackground)
                }
            #endif
    }

    @ViewBuilder
    var textView: some View {
        if truncated {
            truncatedTextView
        } else {
            nontruncatedTextView
        }
    }

    private var nontruncatedTextView: some View {
        Text(text)
            .font(font)
            .foregroundStyle(.primary)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: ClampedHeightKey.self,
                        value: geo.size.height,
                    )
                },
            )
    }

    private var truncatedTextView: some View {
        Button {
            showFullText = true
        } label: {
            Text(text)
                .font(font)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ClampedHeightKey.self,
                            value: geo.size.height,
                        )
                    },
                )
        }
        .focused($hasFocus)
        .buttonStyle(.plain)
        .accessibilityHint("Show full text")
    }

    private func updateTruncation() {
        guard clampedHeight > 0, fullHeight > 0 else { return }
        // adding 1 avoids floating point false positives
        truncated = fullHeight > clampedHeight + 1.0
    }
}

// MARK: - Preference Keys

private struct FullHeightKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct ClampedHeightKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: Preview

#if DEBUG
    #Preview {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    //
                } label: {
                    Text("Text Button to Test Spacing")
                }
            }
            ExpandableTextView(
                """
                Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae
                pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu
                aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas.

                Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class
                aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.
                """,
                font: .caption,
            )
        }
    }
#endif
