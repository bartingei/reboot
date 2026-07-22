/// Backup/restore is a point-in-time export, not live multi-device sync —
/// concurrent edits from two devices can't be merged without server-side
/// decryption, which the privacy model deliberately avoids.
abstract class BackupRepository {
  /// Serializes the local database, encrypts it, and uploads the blob.
  Future<void> backupNow();

  /// Downloads the latest backup blob and decrypts it with the recovery
  /// phrase, then rehydrates the local database.
  Future<void> restore(String recoveryPhrase);
}
