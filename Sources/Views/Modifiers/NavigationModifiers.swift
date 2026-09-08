//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import Motley
import SwiftUI

public extension View {

    // MARK: - Back Navigation

    /// On tvOS, intercepts the Siri Remote Menu button to pop the NavigationStack when
    /// the system navigation bar is hidden. No-op on other platforms where the system
    /// back button handles navigation.
    func backNavigation() -> some View {
        #if os(tvOS)
            modifier(BackNavigationModifier())
        #else
            self
        #endif
    }

    // MARK: - Dismiss Action

    /// Platform-appropriate back/dismiss action.
    /// Shows a visible back button on all platforms.
    /// On tvOS the Menu button also triggers the action via `onExitCommand`.
    /// Pass `subtitle` to show a breadcrumb-style heading beside the back button.
    func dismissAction(
        _ title: String = "Back",
        subtitle: String? = nil,
        perform action: @escaping () -> Void,
    ) -> some View {
        VStack(alignment: .leading, spacing: dismissButtonSpacing) {
            HStack(alignment: .center, spacing: Platform.spacing(.medium)) {
                Button(action: action) {
                    Label(title, symbol: .chevron_left)
                }
                .formButtonStyle()
                if let subtitle {
                    Text(subtitle)
                        .platformFont(.body)
                        .fontWeight(.bold)
                }
            }
            self
        }
        #if os(tvOS)
            .onExitCommand(perform: action)
        #endif
    }
}

/// Spacing between the dismiss button and the page content below it. tvOS
/// needs extra room so the button's focus highlight doesn't overlap the
/// first content row's section label.
private var dismissButtonSpacing: CGFloat {
    #if os(tvOS)
        52
    #else
        16
    #endif
}

// MARK: - Back Navigation (tvOS)

#if os(tvOS)
    /// Pops the NavigationStack when the Siri Remote Menu button is pressed.
    /// Needed for views that hide the system navigation bar — without it,
    /// `.toolbarVisibility(.hidden, for: .navigationBar)` disables automatic back navigation.
    /// Views that show the system nav bar let the system handle Menu.
    private struct BackNavigationModifier: ViewModifier {

        @Environment(\.dismiss) private var dismiss

        func body(content: Content) -> some View {
            content
                .onExitCommand { dismiss() }
        }
    }
#endif
