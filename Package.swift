// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "keccak-swift",
    products: [
        .library(
            name: "Keccak",
            targets: ["Keccak"]),
    ],
    targets: [
        .target(
            name: "Keccak"),
        .testTarget(
            name: "KeccakTests",
            dependencies: ["Keccak"]),
    ]
)
