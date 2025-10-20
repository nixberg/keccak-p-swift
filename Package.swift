// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "keccak-swift",
    products: [
        .library(
            name: "Keccak",
            targets: ["Keccak"])
    ],
    targets: [
        .target(
            name: "Keccak",
            swiftSettings: [
                .strictMemorySafety()
            ]),
        .testTarget(
            name: "KeccakTests",
            dependencies: ["Keccak"]),
    ]
)
