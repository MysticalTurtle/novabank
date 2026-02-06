import 'package:novabank/core/error/failures.dart';
import 'package:novabank/core/utils/result.dart';
import 'package:novabank/data/models/token_response_model.dart';
import 'package:novabank/data/datasources/remote/api_datasource.dart';
import 'package:novabank/data/datasources/secure_storage/secure_storage_datasource.dart';
import 'oauth_handler.dart';

class AuthService {
  final OAuthHandler oAuthHandler;
  final ApiDataSource apiDataSource;
  final SecureStorageDataSource secureStorage;

  AuthService({
    required this.oAuthHandler,
    required this.apiDataSource,
    required this.secureStorage,
  });

  Future<Result<TokenResponseModel>> login() async {
    try {
      final authorizationCode = await oAuthHandler.authenticate();

      final tokenResponse = await apiDataSource.login(authorizationCode);

      await secureStorage.saveAccessToken(tokenResponse.accessToken);
      await secureStorage.saveRefreshToken(tokenResponse.refreshToken);

      return Result.success(tokenResponse);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Login failed: ${e.toString()}'),
      );
    }
  }

  Future<Result<TokenResponseModel>> refreshToken() async {
    try {
      final refreshToken = await secureStorage.getRefreshToken();

      if (refreshToken == null) {
        return Result.failure(
          const AuthenticationFailure('No refresh token available'),
        );
      }

      final tokenResponse = await apiDataSource.refreshToken(refreshToken);

      await secureStorage.saveAccessToken(tokenResponse.accessToken);
      await secureStorage.saveRefreshToken(tokenResponse.refreshToken);

      return Result.success(tokenResponse);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Token refresh failed: ${e.toString()}'),
      );
    }
  }

  Future<Result<void>> logout() async {
    try {
      await apiDataSource.logout();

      await secureStorage.deleteAccessToken();
      await secureStorage.deleteRefreshToken();

      await oAuthHandler.revokeSession();

      return Result.success(null);
    } catch (e) {
      await secureStorage.deleteAccessToken();
      await secureStorage.deleteRefreshToken();

      return Result.failure(
        AuthenticationFailure('Logout failed: ${e.toString()}'),
      );
    }
  }

  Future<bool> isAuthenticated() async {
    final accessToken = await secureStorage.getAccessToken();
    return accessToken != null;
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.getRefreshToken();
  }
}
