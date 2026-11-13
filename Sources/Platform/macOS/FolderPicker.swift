//
// Mosaic – Michael's SwiftUI Toolkit
// Copyright 2025-2026 Wells Consulting.
//

#if os(macOS)
    import AppKit

    /// Asks for one directory, creating one if the person asks for a new one.
    @MainActor
    public enum FolderPicker {

        /// Shows the panel and returns the folder chosen, or `nil` when it's
        /// cancelled.
        ///
        /// - Parameters:
        ///   - message: The line above the list of folders.
        ///   - prompt: The button's title.
        public static func chooseFolder(
            message: String,
            prompt: String = "Choose",
        ) -> URL? {
            let panel = NSOpenPanel()
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.canCreateDirectories = true
            panel.allowsMultipleSelection = false
            panel.prompt = prompt
            panel.message = message

            return panel.runModal() == .OK ? panel.url : nil
        }
    }
#endif
