// swift-tools-version: 5.9
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import PackageDescription

let package = Package(
    name: "skip-salt",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipSalt", targets: ["SkipSalt"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.8.46"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.6.11"),
        .package(url: "https://source.skip.tools/skip-ffi.git", from: "0.3.2"),
        .package(url: "https://github.com/jedisct1/swift-sodium.git", from: "0.9.1"),
    ],
    targets: [
        .target(name: "SkipSalt", dependencies: [.product(name: "SkipFoundation", package: "skip-foundation"), .product(name: "SkipFFI", package: "skip-ffi"), .product(name: "Sodium", package: "swift-sodium")], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipSaltTests", dependencies: ["SkipSalt", .product(name: "SkipTest", package: "skip")], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
