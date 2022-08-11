// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLintTool",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .exact("0.48.0")),
    ],
    targets: [
        .target(name: "SwiftLintTool", path: ""),
    ]
)
