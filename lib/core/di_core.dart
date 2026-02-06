import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:novabank/core/utils/connectivity_service.dart';
import 'package:novabank/data/auth/auth_service.dart';
import 'package:novabank/data/auth/mock_oauth_handler.dart';
import 'package:novabank/data/auth/oauth_handler.dart';
import 'package:novabank/data/client/api_client.dart';
import 'package:novabank/data/datasources/local/local_datasource.dart';
import 'package:novabank/data/datasources/local/local_datasource_impl.dart';
import 'package:novabank/data/datasources/remote/api_datasource.dart';
import 'package:novabank/data/datasources/remote/mock_api_datasource.dart';
import 'package:novabank/data/datasources/secure_storage/secure_storage_datasource.dart';
import 'package:novabank/data/datasources/secure_storage/secure_storage_datasource_impl.dart';
import 'package:novabank/data/repositories/novabank_repository_impl.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';
import 'package:sqflite/sqflite.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDiCore() async {
  // External dependencies
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Initialize database
  final database = await LocalDataSourceImpl.initDatabase();
  getIt.registerLazySingleton<Database>(() => database);

  // Core services
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: 'https://api.novabank.com', // Configure your base URL
      onTokenRefresh: (refreshToken) async {
        // This will be called by ApiClient interceptor when access token expires
        final authService = getIt<AuthService>();
        final result = await authService.refreshToken();
        return result.fold((_) => null, (tokenResponse) => tokenResponse);
      },
      onTokenExpired: () {
        // Handle token expiration (e.g., navigate to login)
        // This could be handled by a global navigator or event bus
      },
    ),
  );

  // OAuth
  getIt.registerLazySingleton<OAuthHandler>(() => MockOAuthHandler());

  // Connectivity
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(connectivity: getIt<Connectivity>()),
  );

  // Data sources
  getIt.registerLazySingleton<ApiDataSource>(() => MockApiDataSource());

  getIt.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(database: getIt<Database>()),
  );

  getIt.registerLazySingleton<SecureStorageDataSource>(
    () => SecureStorageDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  // // Services
  // getIt.registerFactory<AuthCubit>(
  //   () => AuthCubit(repository: getIt<NovabankRepository>()),
  // );

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      oAuthHandler: getIt<OAuthHandler>(),
      apiDataSource: getIt<ApiDataSource>(),
      secureStorage: getIt<SecureStorageDataSource>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<NovabankRepository>(
    () => NovabankRepositoryImpl(
      apiDataSource: getIt<ApiDataSource>(),
      localDataSource: getIt<LocalDataSource>(),
      authService: getIt<AuthService>(),
      apiClient: getIt<ApiClient>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
  );

  // Cubits
  // getIt.registerFactory<AuthCubit>(
  //   () => AuthCubit(repository: getIt<NovabankRepository>()),
  // );

  // getIt.registerFactory<HomeCubit>(
  //   () => HomeCubit(repository: getIt<NovabankRepository>()),
  // );
}
