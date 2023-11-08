// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import Clibsodium
#else
import SkipFFI
private let Clibsodium = SodiumLibrary()
#endif

public class Sodium {
    /// The version of libsodium
    public static let sodiumVersion = String(cString: Clibsodium.sodium_version_string())
}

#if SKIP

// MARK: SodiumLibrary JNA

/// Direct access to the Android Sodium library from Skip.
private func SodiumLibrary() -> SodiumLibrary {
    do {
        // libsodium-jni-aar-2.0.2.aar contains jni/arm64-v8a/libsodiumjni.so, jni/armeabi-v7a/libsodiumjni.so, jni/x86_64/libsodiumjni.so, and jni/x86/libsodiumjni.so
        return com.sun.jna.Native.load("sodiumjni", (SodiumLibrary.self as kotlin.reflect.KClass).java)
    } catch let error as java.lang.UnsatisfiedLinkError {
        // GRADLE> skip.salt.SkipSaltTests > testSkipSalt$SkipSalt_debugAndroidTest[Pixel_6_API_33(AVD) - 13] [31mFAILED [0m
        // GRADLE>     java.lang.UnsatisfiedLinkError: Unable to load library 'sodium':
        // GRADLE>     dlopen failed: library "libsodium.so" not found
        // GRADLE> Tests on Pixel_6_API_33(AVD) - 13 failed: There was 1 failure(s).

        // from brew install libsodium: /opt/homebrew/lib/libsodium.dylib
        System.setProperty("jna.library.path", "/opt/homebrew/lib/:/usr/local/homebrew/lib/:" + System.getProperty("jna.library.path"));

        return com.sun.jna.Native.load("sodium", (SodiumLibrary.self as kotlin.reflect.KClass).java)
    }
}

private protocol SodiumLibrary : com.sun.jna.Library {
    func sodium_version_string() -> OpaquePointer
}

///**
// * Declare all the supported <a href="https://download.libsodium.org/doc/" target="_blank">libsodium</a> C functions in this interface and
// * implement them in this class as static methods.
// *
// */
//public interface Sodium extends Library
//{
//    int sodium_library_version_major();
//    int sodium_library_version_minor();
//    int sodium_init();
//
//    /*
//     * @return version string of the libsodium library
//     * include/sodium/version.h
//     */
//    String sodium_version_string();
//
//    /*
//     * Fills size bytes starting at buf with an unpredictable sequence of bytes.
//     * @param buf  buffer to fill with random bytes
//     * @param size number of random bytes
//     * <a href="https://download.libsodium.org/doc/generating_random_data/">Generating random data</a> libsodium page
//     */
//    void randombytes_buf(byte[] buf, int size);
//
//    /*
//     * see include/sodium/crypto_pwhash.h
//     */
//    int crypto_pwhash_alg_argon2i13();
//    int crypto_pwhash_alg_argon2id13(); // added in libsodium 1.0.15
//    int crypto_pwhash_alg_default();
//    int crypto_pwhash_saltbytes();
//    int crypto_pwhash_strbytes();
//    Pointer crypto_pwhash_strprefix();
//    long crypto_pwhash_opslimit_interactive();
//    NativeLong crypto_pwhash_memlimit_interactive();
//    long crypto_pwhash_opslimit_moderate();
//    NativeLong crypto_pwhash_memlimit_moderate();
//    long crypto_pwhash_opslimit_sensitive();
//    NativeLong crypto_pwhash_memlimit_sensitive();
//
//    /* sodium/crypto_box.h */
//    NativeLong crypto_box_seedbytes();
//    NativeLong crypto_box_publickeybytes();
//    NativeLong crypto_box_secretkeybytes();
//    NativeLong crypto_box_noncebytes();
//    NativeLong crypto_box_macbytes();
//    NativeLong crypto_box_sealbytes();
//
//    /* sodium/crypto_auth.h */
//    NativeLong crypto_auth_bytes();
//    NativeLong crypto_auth_keybytes();
//
//    int crypto_pwhash(byte[] key, long keylen,
//            byte[] passwd, long passwd_len,
//            byte[] in_salt,
//            long opslimit,
//            NativeLong memlimit,
//            int alg);
//
//    int crypto_pwhash_scryptsalsa208sha256(byte[] key, long keyLength,
//            byte[] passwd, long passwd_len,
//            byte[] in_salt,
//            long opslimit,
//            NativeLong memlimit);
//
//    int crypto_pwhash_str(byte[] hashedPassword,
//            byte[] password, long passwordLen,
//            long opslimit, NativeLong memlimit);
//
//    int crypto_pwhash_str_verify(byte[] hashedPassword,
//            byte[] password, long passwordLen);
//
//    /* sodium/crypto_pwhash_scryptsalsa208sha256.h */
//    NativeLong crypto_pwhash_scryptsalsa208sha256_saltbytes();
//
//    /* Secret Key */
//    NativeLong  crypto_secretbox_keybytes();
//    NativeLong  crypto_secretbox_noncebytes();
//    NativeLong  crypto_secretbox_macbytes();
//
//    int crypto_secretbox_easy(byte[] cipherText,
//            byte[] message, long mlen, byte[] nonce,
//            byte[] key);
//
//    int crypto_secretbox_open_easy(byte[] decrypted,
//            byte[] cipherText, long ct_len, byte[] nonce,
//            byte[] key);
//
//    int crypto_secretbox_detached(byte[] cipherText,
//            byte[] mac,
//            byte[] message, long mlen,
//            byte[] nonce, byte[] key);
//
//    int crypto_secretbox_open_detached(byte[] message,
//            byte[] cipherText, byte[] mac, long cipherTextLength,
//            byte[] nonce, byte[] key);
//
//    int crypto_box_seal(byte[] cipherText,
//            byte[] message, long messageLen,
//            byte[] recipientPublicKey);
//
//    int crypto_box_seal_open(byte[] decrypted,
//            byte[] cipherText, long cipherTextLen,
//            byte[] recipientPublicKey, byte[] reciPientPrivateKey);
//
//    int crypto_auth(byte[] mac, byte[] message, long messageLen, byte[] key);
//    int crypto_auth_verify(byte[] mac, byte[] message, long messagelen, byte[] key);
//
//
//    /* Public key authenticated encryption */
//    int crypto_box_keypair(byte[] pk, byte[] sk);
//
//    int crypto_scalarmult(byte[] q, byte[] n, byte[] p);
//   /**
//    * Compute Public key from Private Key
//    * @param pk - Public Key returns
//    * @param sk - Private Key
//    * @return 0 on success -1 on failure
//    */
//    int crypto_scalarmult_base(byte[] pk, byte[] sk);
//
//    int crypto_box_easy(byte[] cipher_text,
//            byte[] plain_text, long pt_len,
//            byte[] nonce,
//            byte[] public_key, byte[] private_key);
//
//    int crypto_box_open_easy(byte[] decrypted, byte[] cipher_text,
//            long ct_len, byte[] nonce,
//            byte[] public_key, byte[] private_key);
//
//    // Signing/Signed keys
//    long crypto_sign_secretkeybytes();
//    long crypto_sign_publickeybytes();
//    int crypto_sign_keypair(byte[] pk, byte[] sk);
//    int crypto_sign_ed25519_bytes();
//    int crypto_sign_bytes();
//
//    // actual signing and verification operations of the Signing key, first detached mode, then combined mode
//    int crypto_sign_detached(byte[] sig, long siglen_p,
//                            byte[]  m, long mlen,
//                            byte[] sk);
//
//    int crypto_sign_verify_detached(byte[] sig, byte[] m,
//                                    long mlen, byte[] pk);
//
//    int crypto_sign(byte[] sm, long smlen_p,
//                    byte[] m, long mlen,
//                    byte[] sk);
//
//    int crypto_sign_open(byte[] m, long mlen_p,
//                        byte[] sm, long smlen,
//                        byte[] pk);
//
//
//    // libsodium's generichash (blake2b), this function will only return outlen number of bytes
//    // key can be null and keylen can be 0
//    int crypto_generichash(byte[] out, int outlen,
//            byte[] in, int inlen,
//            byte[] key, long keylen);
//
//    // key conversion from ED to Curve so that signed key can be used for encryption
//    int crypto_sign_ed25519_sk_to_curve25519(byte[] curveSK, byte[] edSK); // secret key conversion
//    int crypto_sign_ed25519_pk_to_curve25519(byte[] curvePK, byte[] edPK); // public key conversion
//
//}

#endif

