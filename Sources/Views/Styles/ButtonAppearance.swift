//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// Semantic role for `prominenceButtonStyle(_:)`.
public enum ButtonAppearance {

    /// How much weight a neutral button carries.
    public enum Prominence {

        /// The quieter tier, for most buttons.
        case regular

        /// The stronger tier, for the button a view is built around.
        case prominent
    }

    /// A way out of a change, in the warning color.
    case cancel

    /// A close action, in the regular neutral fill.
    case close

    /// The action that completes the job.
    case confirm

    /// An action that deletes or discards.
    case destructive

    /// A neutral button, at either prominence.
    case neutral(Prominence)

    /// A button filled with a color you choose.
    case tinted(Color)

    var prominent: Bool {
        prominence == .prominent
    }

    var prominence: Prominence {
        if case let .neutral(prominence) = self {
            prominence
        } else {
            .regular
        }
    }

    @MainActor
    var fillColor: Color {
        let palette = PaletteStore.shared.current
        return switch self {
        case .cancel:
            palette.warningTint
        case .close:
            palette.neutralRegularBottom
        case .confirm:
            palette.neutralProminentTop
        case .destructive:
            palette.errorTint
        case .neutral:
            prominent ? palette.neutralProminentTop : palette.neutralRegularBottom
        case let .tinted(color):
            color
        }
    }

    @MainActor
    func labelColor(disabled: Bool) -> Color {
        switch self {
        case .neutral:
            return disabled ? .secondary.opacity(0.5) : PaletteStore.shared.current.neutralLabel
        default:
            return disabled ? .secondary.opacity(0.5) : .primary
        }
    }
}
