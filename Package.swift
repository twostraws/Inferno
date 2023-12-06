// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Inferno",
    platforms: [.iOS(.v15), .macOS(.v12), .macCatalyst(.v15), .tvOS(.v15), .visionOS(.v1)],
    products: [
        .library(name: "Inferno", targets: ["Inferno"]),
    ],
    targets: [
        .target(name: "Inferno", resources: [.process("Shaders")]),
    ]
)
