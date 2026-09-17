// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-bifunctor",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Bifunctor",
            targets: ["Bifunctor"]
        ),
        .library(
            name: "Bifunctor Test Support",
            targets: ["Bifunctor Test Support"]
        ),
        .library(name: "Bifunctor Macro", targets: ["Bifunctor Macro"]),
        .library(name: "Bifunctor Macro Core", targets: ["Bifunctor Macro Core"]),
    ],
    dependencies: [

        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-either.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(
            name: "Bifunctor",
            dependencies: [
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .target(
            name: "Bifunctor Test Support",
            dependencies: [
                "Bifunctor"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Bifunctor Tests",
            dependencies: [

                "Bifunctor",
                "Bifunctor Test Support",
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .target(
            name: "Bifunctor Macro Core",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .macro(
            name: "Bifunctor Macro Plugin",
            dependencies: [
                "Bifunctor Macro Core",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "Bifunctor Macro",
            dependencies: ["Bifunctor Macro Plugin"]
        ),
        .testTarget(
            name: "Bifunctor Macro Tests",
            dependencies: ["Bifunctor Macro"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
