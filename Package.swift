// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mosaic",
    platforms: [
        .iOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
        .macOS(.v26),
    ],
    products: [
        .library(name: "Mosaic", targets: ["Mosaic"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wells-consulting/Motley", from: "1.0.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.63.0"),
    ],
    targets: [
        .target(
            name: "Mosaic",
            dependencies: [ "Motley" ],
            path: "Sources",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
                .process("Resources/Media.xcassets"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
                .enableUpcomingFeature("ExistentialAny"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ],
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["Mosaic"],
            path: "Tests",
        ),
    ],
)
