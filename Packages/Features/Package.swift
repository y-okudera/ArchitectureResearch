// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature",
            ]
        ),
        .library(
            name: "SearchRepoFeature",
            targets: [
                "SearchRepoFeature",
            ]
        ),
    ],
    dependencies: [
        // TCA
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.40.2"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.7.4"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.8.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.3.2"),

        // Local
        .package(name: "Clients", path: "../Clients"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Logger", path: "../Logger"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                // Local
                "SearchRepoFeature",
                .product(name: "ApiClient", package: "Clients"),
                .product(name: "Logger", package: "Logger"),
                // Remote
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
            ]
        ),
        .target(
            name: "SearchRepoFeature",
            dependencies: [
                // Local
                .product(name: "ApiClient", package: "Clients"),
                .product(name: "Components", package: "DesignSystem"),
                .product(name: "Representable", package: "DesignSystem"),
                .product(name: "Logger", package: "Logger"),
                // Remote
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .testTarget(
            name: "SearchRepoFeatureTests",
            dependencies: [
                "SearchRepoFeature",
            ]
        ),
    ]
)
