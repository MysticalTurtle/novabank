import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_datasource.dart';

class SecureStorageDataSourceImpl implements SecureStorageDataSource {
  final FlutterSecureStorage secureStorage;

  SecureStorageDataSourceImpl({required this.secureStorage});

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) async {
    await secureStorage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<void> deleteAccessToken() async {
    await secureStorage.delete(key: _accessTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await secureStorage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await secureStorage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> deleteAll() async {
    await secureStorage.deleteAll();
  }
}
