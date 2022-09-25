// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Models",
            targets: [
                "Models",
            ]
        ),
    ],
    dependencies: [
        .package(name: "Logger", path: "../Logger"),
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Logger", package: "Logger"),
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: [
                "Models",
            ]
        ),
    ]
)
