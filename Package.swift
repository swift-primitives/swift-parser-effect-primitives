// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-parser-effect-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Parser Backtrack Primitives",
            targets: ["Parser Backtrack Primitives"]
        ),
        .library(
            name: "Parser Backtrack Primitives Test Support",
            targets: ["Parser Backtrack Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-parser-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-effect-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Parser Backtrack Primitives",
            dependencies: [
                .product(name: "Parser Primitives Core", package: "swift-parser-primitives"),
                .product(name: "Effect Primitives", package: "swift-effect-primitives"),
            ]
        ),
        .target(
            name: "Parser Backtrack Primitives Test Support",
            dependencies: [
                "Parser Backtrack Primitives"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Parser Backtrack Primitives Tests",
            dependencies: [
                "Parser Backtrack Primitives",
                "Parser Backtrack Primitives Test Support",
                .product(
                    name: "Parser Primitives Test Support",
                    package: "swift-parser-primitives"
                ),
            ]
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
