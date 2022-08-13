// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockoloTool",
    dependencies: [
        .package(url: "https://github.com/uber/mockolo", .exact("1.7.0")),
    ],
    targets: [
        .target(name: "MockoloTool", path: ""),
    ]
)
