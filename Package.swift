// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "XCResult2Cobertura",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .executable(
      name: "xcr2c",
      targets: [
        "xcr2c",
        "XCResult2Cobertura"
      ]),

    .library(
      name: "XCResult2CoberturaLib",
      targets: ["XCResult2Cobertura"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-argument-parser.git", 
      exact: "1.2.3"),
  ],
  targets: [
    .executableTarget(
      name: "xcr2c",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .target(name: "XCResult2Cobertura"),
      ],
      path: "Sources/Exe"),

    .target(
      name: "XCResult2Cobertura",
      path: "Sources/Lib"),

    .testTarget(
      name: "XCResult2CoberturaTests",
      dependencies: ["XCResult2Cobertura"],
      path: "Tests"),
  ]
)
