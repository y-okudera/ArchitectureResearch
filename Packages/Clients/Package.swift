// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clients",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ApiClient",
            targets: [
                "ApiClient",
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
        .package(name: "Logger", path: "../Logger"),
        .package(name: "Models", path: "../Models"),
    ],
    targets: [
        .target(
            name: "ApiClient",
            dependencies: [
                .product(name: "Logger", package: "Logger"),
                .product(name: "Models", package: "Models"),
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
            dependencies: [
                "ApiClient",
            ]
        ),
    ]
)
