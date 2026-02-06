import 'package:dio/dio.dart';
import 'package:novabank/data/models/token_response_model.dart';

class ApiClient {
  final Dio _dio;
  String? _accessToken;
  String? _refreshToken;
  final Future<TokenResponseModel?> Function(String refreshToken)?
  onTokenRefresh;
  final void Function()? onTokenExpired;

  ApiClient({String? baseUrl, this.onTokenRefresh, this.onTokenExpired})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? '')) {
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  void setRefreshToken(String? token) {
    _refreshToken = token;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && _refreshToken != null) {
            if (onTokenRefresh != null) {
              try {
                final tokenResponse = await onTokenRefresh!(_refreshToken!);
                if (tokenResponse != null) {
                  setAccessToken(tokenResponse.accessToken);
                  setRefreshToken(tokenResponse.refreshToken);

                  // Retry the original request with new token
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $_accessToken';

                  final response = await _dio.fetch(options);
                  return handler.resolve(response);
                }
              } catch (e) {
                // Token refresh failed
                onTokenExpired?.call();
                return handler.next(error);
              }
            }

            // No refresh callback or refresh token, session expired
            onTokenExpired?.call();
          }
          handler.next(error);
        },
      ),
    );
  }
}
