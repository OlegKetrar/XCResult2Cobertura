// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureOne",
    products: [
        .library(
            name: "FeatureOne",
            targets: ["FeatureOne"]),
    ],
    targets: [
        .target(
            name: "FeatureOne",
            path: "Sources"),

        .testTarget(
            name: "FeatureOneTests",
            dependencies: ["FeatureOne"],
            path: "Tests"),
    ]
)
