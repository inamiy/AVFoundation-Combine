// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AVFoundation-Combine",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "AVFoundation-Combine",
            targets: ["AVFoundation-Combine"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AVFoundation-Combine",
            dependencies: []),
        .testTarget(
            name: "AVFoundation-CombineTests",
            dependencies: ["AVFoundation-Combine"]),
    ]
)
