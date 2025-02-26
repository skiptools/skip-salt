// swift-tools-version: 5.9
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import PackageDescription

let package = Package(
    name: "skip-salt",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipSalt", targets: ["SkipSalt"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-ffi.git", from: "1.0.0"),
        .package(url: "https://github.com/jedisct1/swift-sodium.git", "0.9.1"..<"2.0.0"),
    ],
    targets: [
        .target(name: "SkipSalt", dependencies: [.product(name: "SkipFoundation", package: "skip-foundation"), .product(name: "SkipFFI", package: "skip-ffi"), .product(name: "Sodium", package: "swift-sodium")], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipSaltTests", dependencies: ["SkipSalt", .product(name: "SkipTest", package: "skip")], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
