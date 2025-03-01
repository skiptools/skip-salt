// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
    let sodium: Sodium = Sodium()
    let sodiumLibrary: SodiumLibrary = SodiumLibrary()

    func testSkipSalt() throws {
        if isRobolectric && !FileManager.default.isExecutableFile(atPath: "/opt/homebrew/lib/libsodium.dylib") && !FileManager.default.isExecutableFile(atPath: "/usr/local/lib/libsodium.dylib") {
            // cannot load libsodium on Robolectric: it is a static archive (libsodium.a) when built as part of Clibsodium, and the Android libsodium-jni-aar package only
            // so we can install it manually with: brew install libsodium
            throw XCTSkip("Sodium tests skipped on Robolectric due to lack of shared library to load")
        }

        // isRobolectric: comes from brew install libsodium
        // isAndroid: comes from libsodium-jni-aar-2.0.2.aar (e.g., jni/arm64-v8a/libsodiumjni.so)
        // isMacOS: comes from Clibsodium
        XCTAssertEqual(10, sodiumLibrary.sodium_library_version_major())
        XCTAssertEqual(isAndroid ? 2 : 3, sodiumLibrary.sodium_library_version_minor())
        XCTAssertEqual(isRobolectric ? "1.0.19" : isAndroid ? "1.0.17" : "1.0.18", sodiumLibrary.sodium_version_string())
    }

    // Tests taken from: https://github.com/jedisct1/swift-sodium/blob/master/Tests/SodiumTests/ReadmeTests.swift

    func testAnonymousEncryptionSealedBoxes() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let bobKeyPair = sodium.box.keyPair()!
        let message = "My Test Message".bytes

        let encryptedMessageToBob =
            sodium.box.seal(message: message, recipientPublicKey: bobKeyPair.publicKey)!

        let messageDecryptedByBob =
            sodium.box.open(anonymousCipherText: encryptedMessageToBob,
                            recipientPublicKey: bobKeyPair.publicKey,
                            recipientSecretKey: bobKeyPair.secretKey)

        XCTAssertNotNil(messageDecryptedByBob)
        #endif
    }

    func testKeyExchange() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let aliceKeyPair = sodium.keyExchange.keyPair()!
        let bobKeyPair = sodium.keyExchange.keyPair()!

        let sessionKeyPairForAlice = sodium.keyExchange.sessionKeyPair(publicKey: aliceKeyPair.publicKey,
                                                                       secretKey: aliceKeyPair.secretKey, otherPublicKey: bobKeyPair.publicKey, side: .CLIENT)!
        let sessionKeyPairForBob = sodium.keyExchange.sessionKeyPair(publicKey: bobKeyPair.publicKey,
                                                                     secretKey: bobKeyPair.secretKey, otherPublicKey: aliceKeyPair.publicKey, side: .SERVER)!

        let aliceToBobKeyEquality = sodium.utils.equals(sessionKeyPairForAlice.tx, sessionKeyPairForBob.rx) // true
        let bobToAliceKeyEquality = sodium.utils.equals(sessionKeyPairForAlice.rx, sessionKeyPairForBob.tx) // true

        XCTAssertTrue(aliceToBobKeyEquality)
        XCTAssertTrue(bobToAliceKeyEquality)
        #endif
    }

    func testDetachedSignatures() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let keyPair = sodium.sign.keyPair()!
        let signature = sodium.sign.signature(message: message, secretKey: keyPair.secretKey)!
        if sodium.sign.verify(message: message,
                              publicKey: keyPair.publicKey,
                              signature: signature) {
            // signature is valid
        }
        #endif
    }

    func testAttachedSignatures() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let keyPair = sodium.sign.keyPair()!
        let signedMessage = sodium.sign.sign(message: message, secretKey: keyPair.secretKey)!
        if sodium.sign.open(signedMessage: signedMessage, publicKey: keyPair.publicKey) != nil {
            // signature is valid
        }
        #endif
    }

    func testSecretKeyAuthenticatedEncryption() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let secretKey = sodium.secretBox.key()
        let encrypted: Bytes = sodium.secretBox.seal(message: message, secretKey: secretKey)!
        if sodium.secretBox.open(nonceAndAuthenticatedCipherText: encrypted, secretKey: secretKey) != nil {
            // authenticator is valid, decrypted contains the original message
        }
        #endif
    }

    func testDeterministicHashing() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let h = sodium.genericHash.hash(message: message)

        XCTAssertNotNil(h)
        #endif
    }

    func testKeyedHashing() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let key = "Secret key".bytes
        let h = sodium.genericHash.hash(message: message, key: key)

        XCTAssertNotNil(h)
        #endif
    }

    func testStreaming() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message1 = "My Test ".bytes
        let message2 = "Message".bytes
        let key = "Secret key".bytes
        let stream = sodium.genericHash.initStream(key: key)!
        stream.update(input: message1)
        stream.update(input: message2)
        let h = stream.final()

        XCTAssertNotNil(h)
        #endif
    }

    func testShortOutputHashing() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let key = sodium.randomBytes.buf(length: sodium.shortHash.KeyBytes)!
        let h = sodium.shortHash.hash(message: message, key: key)

        XCTAssertNotNil(h)
        #endif
    }

//    func testRandomNumberGeneration() {
//        let sodium = Sodium()
//        let randomData = sodium.randomBytes.buf(length: 1000)
//
//        XCTAssertNotNil(randomData)
//
//        var rng = RandomBytes.Generator()
//        let randomUInt32 = UInt32.random(in: 0...10, using: &rng)
//        let randomUInt64 = UInt64.random(in: 0...10, using: &rng)
//        let randomInt = Int.random(in: 0...10, using: &rng)
//        let randomDouble = Double.random(in: 0...1, using: &rng)
//
//        XCTAssert(randomUInt32 >= 0 && randomUInt32 <= 10)
//        XCTAssert(randomUInt64 >= 0 && randomUInt64 <= 10)
//        XCTAssert(randomInt >= 0 && randomInt <= 10)
//        XCTAssert(randomDouble >= 0 && randomDouble <= 1)
//    }

    func testPasswordHashing() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let password = "Correct Horse Battery Staple".bytes
        let hashedStr = sodium.pwHash.str(passwd: password,
                                          opsLimit: sodium.pwHash.OpsLimitInteractive,
                                          memLimit: sodium.pwHash.MemLimitInteractive)!

        if sodium.pwHash.strVerify(hash: hashedStr, passwd: password) {
            // Password matches the given hash string
        } else {
            // Password doesn't match the given hash string
        }

        if sodium.pwHash.strNeedsRehash(hash: hashedStr,
                                        opsLimit: sodium.pwHash.OpsLimitInteractive,
                                        memLimit: sodium.pwHash.MemLimitInteractive) {
            // Previously hashed password should be recomputed because the way it was
            // hashed doesn't match the current algorithm and the given parameters.
        }
        #endif
    }

    func testZeroingMemory() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        var dataToZero = "Message".bytes
        sodium.utils.zero(&dataToZero)
        #endif
    }

    func testConstantTimeComparison() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secret1 = "Secret key".bytes
        let secret2 = "Secret key".bytes
        let equality = sodium.utils.equals(secret1, secret2)

        XCTAssertTrue(equality)
        #endif
    }

    func testConstantTimeHexdecimalEncoding() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let data = "Secret key".bytes
        let hex = sodium.utils.bin2hex(data)

        XCTAssertNotNil(hex)
        #endif
    }

    func testHexDecimalDecoding() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let data1 = sodium.utils.hex2bin("deadbeef")
        let data2 = sodium.utils.hex2bin("de:ad be:ef", ignore: " :")

        XCTAssertNotNil(data1)
        XCTAssertNotNil(data2)
        #endif
    }

    func testStream() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let input = "test".bytes
        let key = sodium.stream.key()
        let (output, nonce) = sodium.stream.xor(input: input, secretKey: key)!
        let twice = sodium.stream.xor(input: output, nonce: nonce, secretKey: key)!

        XCTAssertEqual(input, twice)
        #endif
    }

    func testAuth() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let input = "test".bytes
        let key = sodium.auth.key()
        let tag = sodium.auth.tag(message: input, secretKey: key)!
        let tagIsValid = sodium.auth.verify(message: input, secretKey: key, tag: tag)

        XCTAssertTrue(tagIsValid)
        #endif
    }

    func testKeyDerivation() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.keyDerivation.key()

        let subKey1 = sodium.keyDerivation.derive(secretKey: secretKey,
                                                  index: 0, length: 32,
                                                  context: "Context!")!
        let subKey2 = sodium.keyDerivation.derive(secretKey: secretKey,
                                                  index: 1, length: 32,
                                                  context: "Context!")!
        XCTAssertNotEqual(subKey1, subKey2)
        #endif
    }

    func testSecretStream() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message1 = "Message 1".bytes
        let message2 = "Message 2".bytes
        let message3 = "Message 3".bytes

        let secretkey = sodium.secretStream.xchacha20poly1305.key()

        /* stream encryption */

        let stream_enc = sodium.secretStream.xchacha20poly1305.initPush(secretKey: secretkey)!
        let header = stream_enc.header()
        let encrypted1 = stream_enc.push(message: message1)!
        let encrypted2 = stream_enc.push(message: message2)!
        let encrypted3 = stream_enc.push(message: message3, tag: .FINAL)!

        /* stream decryption */

        let stream_dec = sodium.secretStream.xchacha20poly1305.initPull(secretKey: secretkey, header: header)!
        let (message1_dec, tag1) = stream_dec.pull(cipherText: encrypted1)!
        let (message2_dec, tag2) = stream_dec.pull(cipherText: encrypted2)!
        let (message3_dec, tag3) = stream_dec.pull(cipherText: encrypted3)!

        XCTAssertEqual(message1, message1_dec)
        XCTAssertEqual(message2, message2_dec)
        XCTAssertEqual(message3, message3_dec)
        XCTAssertEqual(tag1, .MESSAGE)
        XCTAssertEqual(tag2, .MESSAGE)
        XCTAssertEqual(tag3, .FINAL)
        #endif
    }

    func testBase64() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let b64 = sodium.utils.bin2base64("data".bytes)!
        let b64_2 = sodium.utils.bin2base64("data".bytes, variant: .URLSAFE_NO_PADDING)!

        let data1 = sodium.utils.base642bin(b64)
        let data2 = sodium.utils.base642bin(b64, ignore: " \n")
        let data3 = sodium.utils.base642bin(b64_2, variant: .URLSAFE_NO_PADDING, ignore: " \n")

        XCTAssertEqual(data1!, "data".bytes)
        XCTAssertEqual(data2!, "data".bytes)
        XCTAssertEqual(data3!, "data".bytes)
        #endif
    }

    func testPadding() {
        let sodium = Sodium()
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        var data = "test".bytes

        // make data.count a multiple of 16
        sodium.utils.pad(bytes: &data, blockSize: 16)!

        // restore original size
        sodium.utils.unpad(bytes: &data, blockSize: 16)!
        #endif
    }

    // Tests taken from: https://github.com/jedisct1/swift-sodium/blob/master/Tests/SodiumTests/SodiumTests.swift

    func testBox() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let aliceKeyPair = sodium.box.keyPair()!
        let bobKeyPair = sodium.box.keyPair()!

        let encryptedMessageFromAliceToBob: Bytes = sodium.box.seal(message: message, recipientPublicKey: bobKeyPair.publicKey, senderSecretKey: aliceKeyPair.secretKey)!
        let decrypted = sodium.box.open(nonceAndAuthenticatedCipherText: encryptedMessageFromAliceToBob, senderPublicKey: bobKeyPair.publicKey, recipientSecretKey: aliceKeyPair.secretKey)
        XCTAssertEqual(decrypted!, message)

        let (encryptedMessageFromAliceToBob2, nonce): (Bytes, Box.Nonce) = sodium.box.seal(message: message, recipientPublicKey: bobKeyPair.publicKey, senderSecretKey: aliceKeyPair.secretKey)!
        let decrypted2 = sodium.box.open(authenticatedCipherText: encryptedMessageFromAliceToBob2, senderPublicKey: aliceKeyPair.publicKey, recipientSecretKey: bobKeyPair.secretKey, nonce: nonce)
        XCTAssertEqual(decrypted2!, message)

        let (encryptedMessageFromAliceToBob3, nonce2, mac): (Bytes, Box.Nonce, Box.MAC) = sodium.box.seal(message: message, recipientPublicKey: bobKeyPair.publicKey, senderSecretKey: aliceKeyPair.secretKey)!
        let decrypted3 = sodium.box.open(authenticatedCipherText: encryptedMessageFromAliceToBob3, senderPublicKey: aliceKeyPair.publicKey, recipientSecretKey: bobKeyPair.secretKey, nonce: nonce2, mac: mac)
        XCTAssertEqual(decrypted3!, message)

        let userNonce = sodium.randomBytes.buf(length: sodium.box.NonceBytes)!
        let encryptedMessageFromAliceToBob4: Bytes = sodium.box.seal(message: message, recipientPublicKey: bobKeyPair.publicKey, senderSecretKey: aliceKeyPair.secretKey, nonce: userNonce)!
        let decrypted4 = sodium.box.open(authenticatedCipherText: encryptedMessageFromAliceToBob4, senderPublicKey: bobKeyPair.publicKey, recipientSecretKey: aliceKeyPair.secretKey, nonce: userNonce)
        XCTAssertEqual(message, decrypted4!)

        let encryptedMessageToBob: Bytes = sodium.box.seal(message: message, recipientPublicKey: bobKeyPair.publicKey)!
        let decrypted5 = sodium.box.open(anonymousCipherText: encryptedMessageToBob, recipientPublicKey: bobKeyPair.publicKey,
                                         recipientSecretKey: bobKeyPair.secretKey)
        XCTAssertEqual(decrypted5!, message)

        // beforenm tests
        // The two beforenm keys calculated by Alice and Bob separately should be identical
        let aliceBeforenm = sodium.box.beforenm(recipientPublicKey: bobKeyPair.publicKey, senderSecretKey: aliceKeyPair.secretKey)!
        let bobBeforenm = sodium.box.beforenm(recipientPublicKey: aliceKeyPair.publicKey, senderSecretKey: bobKeyPair.secretKey)!
        XCTAssertEqual(aliceBeforenm, bobBeforenm)

        // Make sure the encryption using beforenm works
        let encryptedMessageBeforenm: Bytes = sodium.box.seal(message: message, beforenm: aliceBeforenm)!
        let decryptedBeforenm = sodium.box.open(nonceAndAuthenticatedCipherText: encryptedMessageBeforenm, beforenm: aliceBeforenm)
        XCTAssertEqual(decryptedBeforenm!, message)

        let (encryptedMessageBeforenm2, nonceBeforenm): (Bytes, Box.Nonce) = sodium.box.seal(message: message, beforenm: aliceBeforenm)!
        let decryptedBeforenm2 = sodium.box.open(authenticatedCipherText: encryptedMessageBeforenm2, beforenm: aliceBeforenm, nonce: nonceBeforenm)
        XCTAssertEqual(decryptedBeforenm2!, message)
        #endif
    }

    func testSecretBox() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let secretKey = sodium.secretBox.key()

        // test simple nonce + mac + message box
        let encrypted: Bytes = sodium.secretBox.seal(message: message, secretKey: secretKey)!
        let decrypted = sodium.secretBox.open(nonceAndAuthenticatedCipherText: encrypted, secretKey: secretKey)!
        XCTAssertEqual(decrypted, message)

        XCTAssertNotEqual(sodium.secretBox.seal(message: message, secretKey: secretKey)!, encrypted, "Ciphertext of two encryption operations on the same plaintext shouldn't be equal. Make sure the nonce was used only once!")

        XCTAssertNil(sodium.secretBox.open(nonceAndAuthenticatedCipherText: encrypted, secretKey: sodium.secretBox.key()), "Shouldn't be able to decrypt with a bad key")

        // test (mac + message, nonce) box
        let (encrypted2, nonce2) = sodium.secretBox.seal(message: message, secretKey: secretKey)!
        let decrypted2 = sodium.secretBox.open(authenticatedCipherText: encrypted2, secretKey: secretKey, nonce: nonce2)
        XCTAssertEqual(decrypted2!, message)

        XCTAssertNil(sodium.secretBox.open(authenticatedCipherText: encrypted2, secretKey: secretKey, nonce: sodium.secretBox.nonce()), "Shouldn't be able to decrypt with an invalid nonce")

        // test (message, nonce, mac) box
        let (encrypted3, nonce3, mac3) = sodium.secretBox.seal(message: message, secretKey: secretKey)!
        let decrypted3 = sodium.secretBox.open(cipherText: encrypted3, secretKey: secretKey, nonce: nonce3, mac: mac3)
        XCTAssertEqual(decrypted3!, message)

        let (encrypted4, nonce4, mac4) = sodium.secretBox.seal(message: message, secretKey: secretKey)!
        XCTAssertNil(sodium.secretBox.open(cipherText: encrypted4, secretKey: secretKey, nonce: nonce3, mac: mac4), "Shouldn't be able to decrypt with an invalid MAC")
        XCTAssertNil(sodium.secretBox.open(cipherText: encrypted4, secretKey: secretKey, nonce: nonce4, mac: mac3), "Shouldn't be able to decrypt with an invalid nonce")

        // reproduce encryption result with user-provided nonce
        let encrypted5 = sodium.secretBox.seal(message: message, secretKey: secretKey, nonce: nonce2)!
        XCTAssertEqual(encrypted5, encrypted2)
        #endif
    }

    func testGenericHash() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let h1 = sodium.utils.bin2hex(sodium.genericHash.hash(message: message)!)!
        XCTAssertEqual(h1, "64a9026fca646c31df54426ad15a341e2444d8a1863d57eb27abecf239609f75")

        let key = sodium.utils.hex2bin("64 a9 02 6f ca 64 6c 31 df 54", ignore: " ")
        let h2 = sodium.utils.bin2hex(sodium.genericHash.hash(message: message, key: key)!)!
        XCTAssertEqual(h2, "1773f324cba2e7b0017e32d7e44f7afd1036c5d4ef9a80ae0e52e95a629844cd")

        let h3 = sodium.utils.bin2hex(sodium.genericHash.hash(message: message, key: key, outputLength: sodium.genericHash.BytesMax)!)!
        XCTAssertEqual(h3, "cba85e39f2d03923b2f66aba99b204333edc34a8443ab1700f7920c7abcc6639963a953f35162a520b21072ab906457d21f1645e6e3985858ee95a84d0771f07")

        let s1 = sodium.genericHash.initStream()!
        XCTAssertTrue(s1.update(input: message))
        let h4 = sodium.utils.bin2hex(s1.final()!)!
        XCTAssertEqual(h4, h1)

        let s2 = sodium.genericHash.initStream(key: key, outputLength: sodium.genericHash.Bytes)!
        XCTAssertTrue(s2.update(input: message))
        let h5 = sodium.utils.bin2hex(s2.final()!)!
        XCTAssertEqual(h5, h2)

        let s3 = sodium.genericHash.initStream(key: key, outputLength: sodium.genericHash.BytesMax)!
        XCTAssertTrue(s3.update(input: message))
        let h6 = sodium.utils.bin2hex(s3.final()!)!
        XCTAssertEqual(h6, h3)
        #endif
    }

    func testRandomBytes() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let randomLen = 100 + Int(sodium.randomBytes.uniform(upperBound: UInt32(100)))
        let random1 = sodium.randomBytes.buf(length: randomLen)!
        let random2 = sodium.randomBytes.buf(length: randomLen)!
        XCTAssertEqual(random1.count, randomLen)
        XCTAssertEqual(random2.count, randomLen)
        XCTAssertNotEqual(random1, random2)

        var c1 = 0
        let ref1 = self.sodium.randomBytes.random()
        for _ in (0..<100) {
            if sodium.randomBytes.random() == ref1 {
                c1 += 1
            }
        }
        XCTAssert(c1 < 10)

        var c2 = 0
        let ref2 = self.sodium.randomBytes.uniform(upperBound: 100_000)
        for _ in (0..<100) {
            if sodium.randomBytes.uniform(upperBound: 100_000) == ref2 {
                c2 += 1
            }
        }
        XCTAssert(c2 < 10)

        let seed = sodium.utils.hex2bin("00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff", ignore: " ")!
        let randomd = sodium.utils.bin2hex(sodium.randomBytes.deterministic(length: 10, seed: seed)!)!
        XCTAssertEqual(randomd, "444dc0602207c270b93f")
        #endif
    }

    func testShortHash() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let key = sodium.utils.hex2bin("00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff", ignore: " ")!
        let h = sodium.utils.bin2hex(sodium.shortHash.hash(message: message, key: key)!)!
        XCTAssertEqual(h, "bb9be85c918015ea")
        #endif
    }

    func testSignature() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = "My Test Message".bytes
        let keyPair = sodium.sign.keyPair(seed: sodium.utils.hex2bin("00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff", ignore: " ")!)!
        let signedMessage = sodium.sign.sign(message: message, secretKey: keyPair.secretKey)!
        XCTAssertEqual(sodium.utils.bin2hex(signedMessage)!, "ce8437d58a27c4d91426d35b24cfaf1e49f95b213c15eddb198f4a8d24c0fdd0df3e7f7a894f60ec15cff25b5f6f27399ce01db0e2649fc54c91cafb8dd48a094d792054657374204d657373616765")

        let signature = sodium.sign.signature(message: message, secretKey: keyPair.secretKey)!
        XCTAssertEqual(sodium.utils.bin2hex(signature)!, "ce8437d58a27c4d91426d35b24cfaf1e49f95b213c15eddb198f4a8d24c0fdd0df3e7f7a894f60ec15cff25b5f6f27399ce01db0e2649fc54c91cafb8dd48a09")

        XCTAssertTrue(sodium.sign.verify(signedMessage: signedMessage, publicKey: keyPair.publicKey))
        XCTAssertTrue(sodium.sign.verify(message: message, publicKey: keyPair.publicKey, signature: signature))

        let unsignedMessage = sodium.sign.open(signedMessage: signedMessage, publicKey: keyPair.publicKey)!
        XCTAssertEqual(unsignedMessage, message)
        #endif
    }

    func testUtils() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        var dataToZero = [1, 2, 3, 4] as [UInt8]
        sodium.utils.zero(&dataToZero)
        XCTAssert(dataToZero == [0, 0, 0, 0] as [UInt8])

        var dataToZero2 = [1, 2, 3, 4] as [UInt8]
        sodium.utils.zero(&dataToZero2)
        XCTAssert(dataToZero2 == [0, 0, 0, 0,] as [UInt8])

        let eq1 = [1, 2, 3, 4] as [UInt8]
        let eq2 = [1, 2, 3, 4] as [UInt8]
        let eq3 = [1, 2, 3, 5] as [UInt8]
        let eq4 = [1, 2, 3] as [UInt8]

        XCTAssertTrue(sodium.utils.equals(eq1, eq2))
        XCTAssertFalse(sodium.utils.equals(eq1, eq3))
        XCTAssertFalse(sodium.utils.equals(eq1, eq4))

        XCTAssertEqual(sodium.utils.compare(eq1, eq2)!,  0)
        XCTAssertEqual(sodium.utils.compare(eq1, eq3)!, -1)
        XCTAssertEqual(sodium.utils.compare(eq3, eq2)!, 1)
        XCTAssertNil(sodium.utils.compare(eq1, eq4))

        let bin = sodium.utils.hex2bin("deadbeef")!
        let hex = sodium.utils.bin2hex(bin)
        XCTAssertEqual(hex, "deadbeef")
        let bin2 = sodium.utils.hex2bin("de-ad be:ef", ignore: ":- ")!
        XCTAssertEqual(bin2, bin)
        #endif
    }

    func testPwHash() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let passwordLen = 4 + Int(sodium.randomBytes.uniform(upperBound: 64))
        let password = sodium.randomBytes.buf(length: passwordLen)!
        let hash = sodium.pwHash.str(passwd: password, opsLimit: sodium.pwHash.OpsLimitInteractive, memLimit: sodium.pwHash.MemLimitInteractive)
        XCTAssertLessThanOrEqual(hash!.lengthOfBytes(using: String.Encoding.utf8), sodium.pwHash.StrBytes)
        let verify = sodium.pwHash.strVerify(hash: hash!, passwd: password)
        XCTAssertTrue(verify)
        let password2 = sodium.randomBytes.buf(length: passwordLen)!
        let verify2 = sodium.pwHash.strVerify(hash: hash!, passwd: password2)
        XCTAssertFalse(verify2)

        let password3 = "My Test Message".bytes
        let salt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] as [UInt8]
        let hash2 = sodium.pwHash.hash(outputLength: 64, passwd: password3, salt: salt, opsLimit: sodium.pwHash.OpsLimitInteractive, memLimit: sodium.pwHash.MemLimitInteractive)
        XCTAssertEqual(sodium.utils.bin2hex(hash2!)!, "cc80dee6a19da46ed6ea11507dd709ce52519ddd1fd2d823ce85b9e9b4fd96d06583de2ca8bcc5998f3483a8a424c4e93ddb500968b0dbefb667d56d421d5a6c")

        XCTAssertFalse(sodium.pwHash.strNeedsRehash(hash: hash!, opsLimit: sodium.pwHash.OpsLimitInteractive, memLimit: sodium.pwHash.MemLimitInteractive))
        XCTAssertTrue(sodium.pwHash.strNeedsRehash(hash: hash!, opsLimit: sodium.pwHash.OpsLimitSensitive, memLimit: sodium.pwHash.MemLimitSensitive))
        #endif
    }

    func testKeyExchange2() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let aliceKeyPair = sodium.keyExchange.keyPair()!
        let bobKeyPair = sodium.keyExchange.keyPair()!

        let sessionKeyPairForAlice = sodium.keyExchange.sessionKeyPair(publicKey: aliceKeyPair.publicKey, secretKey: aliceKeyPair.secretKey, otherPublicKey: bobKeyPair.publicKey, side: .CLIENT)!
        let sessionKeyPairForBob = sodium.keyExchange.sessionKeyPair(publicKey: bobKeyPair.publicKey, secretKey: bobKeyPair.secretKey, otherPublicKey: aliceKeyPair.publicKey, side: .SERVER)!

        XCTAssertEqual(sessionKeyPairForAlice.rx, sessionKeyPairForBob.tx)
        XCTAssertEqual(sessionKeyPairForAlice.tx, sessionKeyPairForBob.rx)
        #endif
    }

    func testStream2() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let key = sodium.stream.key()
        let inputLen = Int(sodium.randomBytes.uniform(upperBound: 1024))
        let input = sodium.randomBytes.buf(length: inputLen)!
        let (output, nonce) = sodium.stream.xor(input: input, secretKey: key)!
        let twice = sodium.stream.xor(input: output, nonce: nonce, secretKey: key)!

        XCTAssertEqual(input, twice)
        #endif
    }

    func testAuth2() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let key = sodium.utils.hex2bin("eea6a7251c1e72916d11c2cb214d3c252539121d8e234e652d651fa4c8cff880")!
        let message = sodium.utils.hex2bin("8e993b9f48681273c29650ba32fc76ce48332ea7164d96a4476fb8c531a1186ac0dfc17c98dce87b4da7f011ec48c97271d2c20f9b928fe2270d6fb863d51738b48eeee314a7cc8ab932164548e526ae90224368517acfeabd6bb3732bc0e9da99832b61ca01b6de56244a9e88d5f9b37973f622a43d14a6599b1f654cb45a74e355a5")!
        let tag = sodium.auth.tag(message: message, secretKey: key)!
        XCTAssertEqual(sodium.utils.bin2hex(tag)!, "b2a31b8d4e01afcab2ee545b5caf4e3d212a99d7b3a116a97cec8e83c32e107d")
        let verify = sodium.auth.verify(message: message, secretKey: key, tag: tag)
        XCTAssertTrue(verify)
        let key2 = sodium.auth.key()
        let verify2 = sodium.auth.verify(message: message, secretKey: key2, tag: tag)
        XCTAssertFalse(verify2)
        #endif
    }

    func testKeyDerivationInputKeyTooShort() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.randomBytes.buf(length: sodium.keyDerivation.KeyBytes - 1)!

        XCTAssertNil(sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST"))
        #endif
    }

    func testKeyDerivationInputKeyTooLong() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.randomBytes.buf(length: sodium.keyDerivation.BytesMax + 1)!
        XCTAssertNil(sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST"))
        #endif
    }

    func testKeyDerivationSubKeyTooShort() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.keyDerivation.key()
        XCTAssertNil(sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin - 1, context: "TEST"))
        #endif
    }

    func testKeyDerivationSubKeyTooLong() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.keyDerivation.key()
        XCTAssertNil(sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMax + 1, context: "TEST"))
        #endif
    }

    func testKeyDerivationContextTooLong() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.keyDerivation.key()
        XCTAssertNil(sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST_SODIUM"))
        #endif
    }

    func testKeyDerivation2() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.keyDerivation.key()
        let subKey1 = sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST")!
        let subKey2 = sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST")!
        let subKey3 = sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST\0")!
        let subKey4 = sodium.keyDerivation.derive(secretKey: secretKey, index: 1, length: sodium.keyDerivation.BytesMin, context: "TEST")!
        let subKey5 = sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "test")!

        XCTAssertEqual(subKey1, subKey2, "Equally derived keys must be equal!")
        XCTAssertEqual(subKey1, subKey3, "Manual padding should result in same key.")

        XCTAssertNotEqual(subKey1, subKey4, "Subkeys with different indices must be different!")
        XCTAssertNotEqual(subKey1, subKey5, "Subkeys with different contexts must be different!")
        #endif
    }

    func testKeyDerivationRegression() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.utils.hex2bin("a9029ec4ec56dd6f3ce5a5fa27a17a005ce73a5b8e77529887f24f73ffa10d67")!
        let subKey1 = sodium.keyDerivation.derive(secretKey: secretKey, index: 0, length: sodium.keyDerivation.BytesMin, context: "TEST")!
        let subKey2 = sodium.keyDerivation.derive(secretKey: secretKey, index: 1, length: sodium.keyDerivation.BytesMin, context: "TEST")!

        XCTAssertEqual(sodium.utils.bin2hex(subKey1)!, "40d69c5e6e8b46e399433c9b5c3a7713")
        XCTAssertEqual(sodium.utils.bin2hex(subKey2)!, "8ba83c1cd5a3be912a80ef2abe1457c5")
        #endif
    }

    func testSecretStream2() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let secretKey = sodium.secretStream.xchacha20poly1305.key()
        XCTAssertEqual(secretKey.count, 32)

        let stream = sodium.secretStream.xchacha20poly1305.initPush(secretKey: secretKey)!
        let header = stream.header()
        let encrypted1 = stream.push(message: "message 1".bytes)!
        let encrypted2 = stream.push(message: "message 2".bytes)!
        let encrypted3 = stream.push(message: "message 3".bytes, tag: .FINAL)!

        let stream2 = sodium.secretStream.xchacha20poly1305.initPull(secretKey: secretKey, header: header)!
        let (message1, tag1) = stream2.pull(cipherText: encrypted1)!
        let (message2, tag2) = stream2.pull(cipherText: encrypted2)!
        let (message3, tag3) = stream2.pull(cipherText: encrypted3)!
        XCTAssertEqual(tag1, .MESSAGE)
        XCTAssertEqual(tag2, .MESSAGE)
        XCTAssertEqual(tag3, .FINAL)
        XCTAssertEqual(message1, "message 1".bytes)
        XCTAssertEqual(message2, "message 2".bytes)
        XCTAssertEqual(message3, "message 3".bytes)
        XCTAssertNil(stream2.pull(cipherText: encrypted3))
        #endif
    }

    func testBase642() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let bin = "test".bytes
        let b64 = sodium.utils.bin2base64(bin)!
        let bin2 = sodium.utils.base642bin(b64)!
        XCTAssertEqual(b64, "dGVzdA==")
        XCTAssertEqual(bin2, bin)

        let b64_nopad = sodium.utils.bin2base64(bin, variant: .URLSAFE_NO_PADDING)!
        let bin2_nopad = sodium.utils.base642bin(b64_nopad, variant: .URLSAFE_NO_PADDING)!
        XCTAssertEqual(b64_nopad, "dGVzdA")
        XCTAssertEqual(bin2_nopad, bin)
        #endif
    }

    func testPad() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        var data = "test".bytes
        sodium.utils.pad(bytes: &data, blockSize: 16)!
        XCTAssertTrue(data.count % 16 == 0)
        sodium.utils.unpad(bytes: &data, blockSize: 16)!
        XCTAssertTrue(data.count == 4)
        #endif
    }

    func testAead() {
        #if SKIP
        throw XCTSkip("SKIP TODO")
        #else
        let message = " I am message".bytes
        let additionalData = "I am additionalData".bytes

        let secretKey = sodium.aead.xchacha20poly1305ietf.key()
        XCTAssertEqual(secretKey.count, 32)

        let (authenticatedCipherText, nonce) = sodium.aead.xchacha20poly1305ietf.encrypt(message: message, secretKey: secretKey)!

        XCTAssertEqual(nonce.count, 24) // check nonce is 192 bit

        let decrypted: Bytes = sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherText, secretKey: secretKey, nonce: nonce)!

        XCTAssertTrue(decrypted == message)

        let (authenticatedCipherTextWithAdditionalData, nonceWithAdditionlData) = sodium.aead.xchacha20poly1305ietf.encrypt(message: message, secretKey: secretKey, additionalData: additionalData)!
        let decrypted2: Bytes = sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherTextWithAdditionalData, secretKey: secretKey, nonce: nonceWithAdditionlData, additionalData: additionalData)!

        XCTAssertTrue(decrypted2 == message)

        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherText, secretKey: secretKey, nonce: nonceWithAdditionlData, additionalData: additionalData), "Decrypt using additionalData but encrypted without")
        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherTextWithAdditionalData, secretKey: secretKey, nonce: nonceWithAdditionlData), "Decrypt without additionalData but encrypted with additionalData")

        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherText, secretKey: sodium.aead.xchacha20poly1305ietf.key(), nonce: nonce), "Decrypt with different key")

        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherTextWithAdditionalData, secretKey: secretKey, nonce: nonceWithAdditionlData, additionalData: "wrong".bytes), "Decrypt with wrong additional data")
        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: "wrong".bytes, secretKey: secretKey, nonce: nonce))

        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherText, secretKey: secretKey, nonce: "invalid".bytes))
        XCTAssertNil(sodium.aead.xchacha20poly1305ietf.decrypt(authenticatedCipherText: authenticatedCipherText, secretKey: "invalid".bytes, nonce: nonce))

        let nonceAndAuthenticatedCipherText: Bytes = sodium.aead.xchacha20poly1305ietf.encrypt(message: message, secretKey: secretKey)!
        let decrypted3: Bytes = sodium.aead.xchacha20poly1305ietf.decrypt(nonceAndAuthenticatedCipherText: nonceAndAuthenticatedCipherText, secretKey: secretKey)!

        XCTAssertTrue(decrypted3 == message)

        let nonceAndAuthenticatedCipherTextWithAddData: Bytes = sodium.aead.xchacha20poly1305ietf.encrypt(message: message, secretKey: secretKey, additionalData: additionalData)!
        let decrypted4: Bytes = sodium.aead.xchacha20poly1305ietf.decrypt(nonceAndAuthenticatedCipherText: nonceAndAuthenticatedCipherTextWithAddData, secretKey: secretKey, additionalData: additionalData)!

        XCTAssertTrue(decrypted4 == message)

        // encrypt -> decrypt empty message
        let emptyMessage = "".bytes
        let encryptedEmpty: Bytes = sodium.aead.xchacha20poly1305ietf.encrypt(message: emptyMessage, secretKey: secretKey, additionalData: additionalData)!
        let decryptedEmpty: Bytes = sodium.aead.xchacha20poly1305ietf.decrypt(nonceAndAuthenticatedCipherText: encryptedEmpty, secretKey: secretKey, additionalData: additionalData)!

        XCTAssertTrue(decryptedEmpty == emptyMessage)
        #endif
    }
}

#if !SKIP
extension String {
    func toData() -> Data? {
        return self.data(using: .utf8, allowLossyConversion: false)
    }
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
#endif
