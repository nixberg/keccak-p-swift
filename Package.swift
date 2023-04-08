// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "keccak-p-swift",
    products: [
        .library(
            name: "KeccakP",
            targets: ["KeccakP"]),
    ],
    targets: [
        .target(
            name: "KeccakP"),
        .testTarget(
            name: "KeccakPTests",
            dependencies: ["KeccakP"]),
    ]
)
