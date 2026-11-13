//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

#if os(tvOS)
    import UIKit
#endif

/// A scrollable text overlay for displaying long-form content.
///
/// On tvOS the view presents a frosted glass panel similar to the Info panel
/// in `AVPlayerViewController`, sized to match the player's content area.
/// A `UITextView` (wrapped via `UIViewRepresentable`) handles Siri Remote
/// scrolling natively through the tvOS focus engine.
///
/// On iOS/macOS the view wraps in a `NavigationStack` with a title bar and
/// dismiss button — suitable for `.sheet` presentation. Pass `navigationBackground`
/// to match the host app's container background treatment on iOS; macOS ignores it.
public struct ScrollableTextView: View {

    // MARK: - Fields

    let title: String?
    let text: String
    let navigationBackground: AnyShapeStyle?

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer

    public init(text: String, title: String? = nil, navigationBackground: AnyShapeStyle? = nil) {
        self.title = title
        self.text = text
        self.navigationBackground = navigationBackground
    }

    // MARK: - Body

    public var body: some View {
        #if os(tvOS)
            tvOSBody
        #else
            standardBody
        #endif
    }

    // MARK: - Subviews

    #if os(tvOS)
        private static let panelWidth: CGFloat = 1260
        private static let panelPadding: CGFloat = 40
        private static let titleSpacing: CGFloat = 16
        private static let minPanelHeight: CGFloat = 200
        private static let maxPanelHeight: CGFloat = 540
        private static let panelCornerRadius: CGFloat = 20

        private var tvOSBody: some View {
            VStack(alignment: .leading, spacing: Self.titleSpacing) {
                if let title {
                    Text(title)
                        .font(.title3.bold())
                }

                FocusableTextView(text: text)
            }
            .padding(Self.panelPadding)
            .frame(
                width: Self.panelWidth,
                height: estimatedPanelHeight,
                alignment: .topLeading,
            )
            .background(.thinMaterial, in: .rect(cornerRadius: Self.panelCornerRadius))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .presentationBackground(.black.opacity(0.3))
            .onExitCommand { dismiss() }
        }

        /// Estimates the panel height by measuring the text with UIKit, then
        /// clamping between `minPanelHeight` and `maxPanelHeight`.
        private var estimatedPanelHeight: CGFloat {
            let contentWidth = Self.panelWidth - Self.panelPadding * 2
            let font = UIFont.preferredFont(forTextStyle: .body)
            let textHeight = (text as NSString).boundingRect(
                with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil,
            ).height

            // Account for title, spacing, and top/bottom padding.
            let titleHeight: CGFloat = title != nil ? 40 : 0
            let totalContent = textHeight + titleHeight + Self.titleSpacing + Self.panelPadding * 2
            return min(max(totalContent, Self.minPanelHeight), Self.maxPanelHeight)
        }
    #else
        private var standardBody: some View {
            NavigationStack {  // Navigation stack audit: safe; used in .sheet
                ScrollView {
                    Text(text)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .mosaicEnableTextSelection()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .scrollBounceBehavior(.basedOnSize)
                .navigationTitle(title ?? String())
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    .containerBackground(for: .navigation) {
                        if let navigationBackground {
                            Rectangle().fill(navigationBackground)
                                .transaction { $0.animation = nil }
                        }
                    }
                #endif
            }
        }
    #endif
}

// MARK: - tvOS Focusable Text View

#if os(tvOS)

    /// A focusable `UIScrollView` wrapper that scrolls via the Siri Remote.
    ///
    /// On tvOS, `UIScrollView` only receives pan gesture input when it is the
    /// focused view. This wrapper uses a `FocusableScrollView` subclass that
    /// overrides `canBecomeFocused` to return `true`, allowing it to accept
    /// focus and respond to Siri Remote swipe input.
    private struct FocusableTextView: UIViewRepresentable {

        let text: String

        func makeUIView(context: Context) -> FocusableScrollView {
            let scrollView = FocusableScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.backgroundColor = .clear
            scrollView.panGestureRecognizer.allowedTouchTypes = [
                NSNumber(value: UITouch.TouchType.indirect.rawValue)
            ]

            let label = UILabel()
            label.text = text
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.textColor = .white
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                label.leadingAnchor.constraint(
                    equalTo: scrollView.contentLayoutGuide.leadingAnchor
                ),
                label.trailingAnchor.constraint(
                    equalTo: scrollView.contentLayoutGuide.trailingAnchor
                ),
                label.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                label.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
            ])

            return scrollView
        }

        func updateUIView(_ scrollView: FocusableScrollView, context: Context) {
            if let label = scrollView.subviews.compactMap({ $0 as? UILabel }).first {
                label.text = text
            }
        }
    }

    /// A `UIScrollView` subclass that can become focused on tvOS.
    private final class FocusableScrollView: UIScrollView {

        override var canBecomeFocused: Bool {
            true
        }
    }

#endif

// MARK: - Preview

#if DEBUG
    #Preview("Short Text") {
        ScrollableTextView(
            text:
                "This application uses open-source software. See individual packages for license details.",
            title: "Acknowledgements",
        )
    }

    #Preview("Long Text") {
        ScrollableTextView(
            text: (1...50).map {
                "Paragraph \($0): "
                    + String(
                        repeating: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                        count: 5
                    )
            }.joined(separator: "\n\n"),
            title: "Terms of Service",
        )
    }
#endif
