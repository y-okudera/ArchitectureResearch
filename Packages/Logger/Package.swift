// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logger",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Logger",
            targets: [
                "Logger",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Logger",
            dependencies: []
        ),
    ]
)
