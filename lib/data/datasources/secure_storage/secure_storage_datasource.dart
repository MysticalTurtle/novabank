/// Interface for secure storage operations (tokens, sensitive data)
abstract class SecureStorageDataSource {
  /// Stores access token securely
  Future<void> saveAccessToken(String token);

  /// Retrieves access token from secure storage
  Future<String?> getAccessToken();

  /// Deletes refresh token
  Future<void> deleteRefreshToken();

  /// Stores refresh token securely
  Future<void> saveRefreshToken(String token);

  /// Retrieves refresh token from secure storage
  Future<String?> getRefreshToken();

  /// Deletes access token
  Future<void> deleteAccessToken();

  /// Deletes all secure data (logout)
  Future<void> deleteAll();
}
