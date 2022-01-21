// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "live-edge-query",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMinor(from: "1.0.2")
        ),
        .package(
            url: "https://github.com/Comcast/mamba.git",
            .exact("1.5.5")
        )
    ],
    targets: [
        .executableTarget(
            name: "live-edge-query",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "mamba", package: "mamba")
            ]
        ),
    ]
)
