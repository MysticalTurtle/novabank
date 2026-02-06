abstract class SecureStorageDataSource {
  Future<void> saveAccessToken(String token);

  Future<String?> getAccessToken();

  Future<void> deleteRefreshToken();

  Future<void> saveRefreshToken(String token);

  Future<String?> getRefreshToken();

  Future<void> deleteAccessToken();

  Future<void> deleteAll();
}
