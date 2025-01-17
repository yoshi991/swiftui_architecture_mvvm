// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2"),
        .package(url: "https://github.com/SwiftGen/SwiftGen", from: "6.6.1"),
    ],
    targets: [.target(name: "Tools", path: "")]
)
