// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
#if !SKIP
import Clibsodium
@_exported import Sodium
#else
import SkipFFI
#endif

#if SKIP
public struct Sodium {
//    public let box = Box()
//    public let secretBox = SecretBox()
//    public let genericHash = GenericHash()
//    public let pwHash = PWHash()
//    public let randomBytes = RandomBytes()
//    public let shortHash = ShortHash()
//    public let sign = Sign()
//    public let utils = Utils()
//    public let keyExchange = KeyExchange()
//    public let auth = Auth()
//    public let stream = Stream()
//    public let keyDerivation = KeyDerivation()
//    public let secretStream = SecretStream()
//    public let aead = Aead()

    public init() {
//        _ = Sodium.once
    }
}
#endif

final class SodiumLibrary {
    init() {
        #if SKIP
        do {
            // libsodium-jni-aar-2.0.2.aar contains jni/arm64-v8a/libsodiumjni.so, jni/armeabi-v7a/libsodiumjni.so, jni/x86_64/libsodiumjni.so, and jni/x86/libsodiumjni.so
            com.sun.jna.Native.register((SodiumLibrary.self as kotlin.reflect.KClass).java, "sodiumjni")
        } catch let error as java.lang.UnsatisfiedLinkError {
            // GRADLE> skip.salt.SkipSaltTests > testSkipSalt$SkipSalt_debugAndroidTest[Pixel_6_API_33(AVD) - 13] [31mFAILED [0m
            // GRADLE>     java.lang.UnsatisfiedLinkError: Unable to load library 'sodium':
            // GRADLE>     dlopen failed: library "libsodium.so" not found
            // GRADLE> Tests on Pixel_6_API_33(AVD) - 13 failed: There was 1 failure(s).
            // from brew install libsodium: /opt/homebrew/lib/libsodium.dylib
            System.setProperty("jna.library.path", "/opt/homebrew/lib/:/usr/local/lib/:" + System.getProperty("jna.library.path"));
            com.sun.jna.Native.register((SodiumLibrary.self as kotlin.reflect.KClass).java, "sodium")
        }
        #endif
    }

    // SKIP INSERT: @JvmName("sodium_init")
    // SKIP EXTERN
    func sodium_init() -> Int32 {
        Clibsodium.sodium_init()
    }

    // SKIP INSERT: @JvmName("sodium_version_string")
    // SKIP EXTERN
    func sodium_version_string() -> String? {
        Clibsodium.sodium_version_string().flatMap({ String(cString: $0) })
    }

    // SKIP INSERT: @JvmName("sodium_library_version_major")
    // SKIP EXTERN
    func sodium_library_version_major() -> Int32 {
        Clibsodium.sodium_library_version_major()
    }

    // SKIP INSERT: @JvmName("sodium_library_version_minor")
    // SKIP EXTERN
    func sodium_library_version_minor() -> Int32 {
        Clibsodium.sodium_library_version_minor()
    }

//    // SKIP EXTERN
//    func randombytes_seedbytes() -> Int64 {
//        Clibsodium.randombytes_seedbytes()
//    }

    // SKIP INSERT: @JvmName("randombytes_random")
    // SKIP EXTERN
    func randombytes_random() -> UInt32 {
        Clibsodium.randombytes_random()
    }

    // SKIP INSERT: @JvmName("randombytes_uniform")
    // SKIP EXTERN
    func randombytes_uniform(_ upperBound: UInt32) -> UInt32 {
        Clibsodium.randombytes_uniform(upperBound)
    }

}
