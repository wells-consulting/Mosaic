//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

import SwiftUI

/// Semantic role for `formButtonStyle(_:)`.
public enum ButtonAppearance {

    public enum Prominence { case regular, prominent }

    case cancel
    case close
    case confirm
    case destructive
    case neutral(Prominence)
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
        let palette = PaletteStore.shared.palette
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
            return disabled ? .secondary.opacity(0.5) : PaletteStore.shared.palette.neutralLabel
        default:
            return disabled ? .secondary.opacity(0.5) : .primary
        }
    }
}
