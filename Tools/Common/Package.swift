// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    dependencies: [
        .package(url: "https://github.com/mono0926/LicensePlist", .exact("3.22.4")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", .exact("0.49.17")),
    ],
    targets: [
        .target(name: "Common", path: ""),
    ]
)
