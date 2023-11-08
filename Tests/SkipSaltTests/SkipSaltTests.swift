// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation
@testable import SkipSalt

let logger: Logger = Logger(subsystem: "SkipSalt", category: "Tests")

/// True when running in a transpiled Java runtime environment
let isJava = ProcessInfo.processInfo.environment["java.io.tmpdir"] != nil
/// True when running within an Android environment (either an emulator or device)
let isAndroid = isJava && ProcessInfo.processInfo.environment["ANDROID_ROOT"] != nil
/// True is the transpiled code is currently running in the local Robolectric test environment
let isRobolectric = isJava && !isAndroid

@available(macOS 13, *)
final class SkipSaltTests: XCTestCase {
    func testSkipSalt() throws {
        if isRobolectric && !FileManager.default.isExecutableFile(atPath: "/opt/homebrew/lib/libsodium.dylib") && !FileManager.default.isExecutableFile(atPath: "/usr/local/lib/libsodium.dylib") {
            // cannot load libsodium on Robolectric: it is a static archive (libsodium.a) when built as part of Clibsodium, and the Android libsodium-jni-aar package only
            // so we can install it manually with: brew install libsodium
            throw XCTSkip("Sodium tests skipped on Robolectric due to lack of shared library to load")
        }

        // isRobolectric: comes from brew install libsodium
        // isAndroid: comes from libsodium-jni-aar-2.0.2.aar (e.g., jni/arm64-v8a/libsodiumjni.so)
        // isMacOS: comes from Clibsodium
        XCTAssertEqual(isRobolectric ? "1.0.19" : isAndroid ? "1.0.17" : "1.0.18", Sodium.sodiumVersion)
    }
}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
