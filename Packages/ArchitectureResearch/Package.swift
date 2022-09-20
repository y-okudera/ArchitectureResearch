// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArchitectureResearch",
    platforms: [
        //        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ApiClient",
            targets: ["ApiClient"]
        ),
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "Components",
            targets: ["Components"]
        ),
        .library(
            name: "Logger",
            targets: ["Logger"]
        ),
        .library(
            name: "Models",
            targets: ["Models"]
        ),
        .library(
            name: "SearchRepoFeature",
            targets: ["SearchRepoFeature"]
        ),
    ],
    dependencies: [
        // For downloading and caching images
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.3.2"),
        // For renders vector-based animations and art in realtime.
        .package(url: "https://github.com/airbnb/lottie-ios", from: "3.4.3"),
        // An extension to SwiftUI that will add the UISearchController.
        .package(url: "https://github.com/markvanwijnen/NavigationSearchBar.git", from: "1.3.0"),

        // TCA
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.40.2"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.7.4"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.8.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.3.2"),
    ],
    targets: [
        .target(
            name: "ApiClient",
            dependencies: [
                "Logger",
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .testTarget(
            name: "ApiClientTests",
            dependencies: ["ApiClient"]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "ApiClient",
                "Logger",
                "SearchRepoFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .target(
            name: "Components",
            dependencies: [
                "ApiClient",
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "NavigationSearchBar", package: "NavigationSearchBar"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .target(
            name: "Logger",
            dependencies: []
        ),
        .target(
            name: "Models",
            dependencies: [
                "Logger",
            ]
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Models"]
        ),
        .target(
            name: "SearchRepoFeature",
            dependencies: [
                "Components",
                "ApiClient",
                "Logger",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
    ]
)
