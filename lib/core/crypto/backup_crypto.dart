/// Client-side encryption for the opt-in encrypted backup feature.
///
/// The recovery phrase and derived key never leave the device — the
/// server only ever receives ciphertext. See ARCHITECTURE.md for the
/// full privacy model.
abstract class BackupCrypto {
  /// Derives a 256-bit key from the user's recovery phrase (Argon2id).
  Future<List<int>> deriveKey(String recoveryPhrase, List<int> salt);

  /// Encrypts [plaintext] with AES-256-GCM under [key], returning
  /// ciphertext and nonce.
  Future<({List<int> ciphertext, List<int> nonce})> encrypt(
    List<int> plaintext,
    List<int> key,
  );

  /// Decrypts a previously-encrypted backup blob.
  Future<List<int>> decrypt(
    List<int> ciphertext,
    List<int> nonce,
    List<int> key,
  );
}
