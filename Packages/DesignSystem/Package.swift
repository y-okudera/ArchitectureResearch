// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Components",
            targets: [
                "Components",
            ]
        ),
        .library(
            name: "Representable",
            targets: [
                "Representable",
            ]
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

        // Local
        .package(name: "Models", path: "../Models"),
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                // Local
                .product(name: "Models", package: "Models"),
                // Remote
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "NavigationSearchBar", package: "NavigationSearchBar"),
            ]
        ),
        .testTarget(
            name: "ComponentTests",
            dependencies: [
                "Components",
            ]
        ),
        .target(
            name: "Representable",
            dependencies: [
                // Local
                .product(name: "Models", package: "Models"),
                // Remote
                .product(name: "Lottie", package: "lottie-ios"),
            ]
        ),
        .testTarget(
            name: "RepresentableTests",
            dependencies: [
                "Representable",
            ]
        ),
    ]
)
