import 'package:dio/dio.dart';
import 'package:novabank/core/error/failures.dart';
import 'package:novabank/core/utils/result.dart';
import 'package:novabank/data/auth/auth_service.dart';
import 'package:novabank/data/client/api_client.dart';
import 'package:novabank/data/datasources/local/local_datasource.dart';
import 'package:novabank/data/datasources/remote/api_datasource.dart';
import 'package:novabank/data/models/models.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';

class NovabankRepositoryImpl implements NovabankRepository {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;
  final AuthService authService;
  final ApiClient apiClient;

  NovabankRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
    required this.authService,
    required this.apiClient,
  });

  @override
  Future<Result<void>> login() async {
    try {
      final result = await authService.login();

      return result.fold((failure) => Result.failure(failure), (tokenResponse) {
        apiClient.setAccessToken(tokenResponse.accessToken);
        apiClient.setRefreshToken(tokenResponse.refreshToken);
        return Result.success(null);
      });
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Login failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final result = await authService.logout();

      // Clear tokens from ApiClient
      apiClient.clearTokens();

      // Clear local cache
      await localDataSource.clearAll();

      return result.fold(
        (failure) => Result.failure(failure),
        (_) => Result.success(null),
      );
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Logout failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<bool> checkIsLoggedIn() async {
    return await authService.isAuthenticated();
  }

  @override
  Future<Result<List<AccountModel>>> getAccounts() async {
    try {
      // Try to fetch from remote
      final accounts = await apiDataSource.getAccounts();

      // Cache the results
      await localDataSource.saveAccounts(accounts);

      return Result.success(accounts);
    } on DioException catch (e) {
      // On network error, try to return cached data
      if (_isNetworkError(e)) {
        try {
          final cachedAccounts = await localDataSource.getAccounts();
          if (cachedAccounts.isNotEmpty) {
            return Result.success(cachedAccounts);
          }
        } catch (_) {
          // Ignore cache errors
        }
        return Result.failure(const NetworkFailure());
      }

      return Result.failure(_mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedTransactionsResponse>> getAccountTransactions(
    String accountId, {
    int? page,
  }) async {
    try {
      final response = await apiDataSource.getAccountTransactions(
        accountId,
        page: page,
      );

      // Cache the results
      await localDataSource.saveAccountTransactions(
        accountId,
        response.transactions,
        page: page,
      );

      return Result.success(response);
    } on DioException catch (e) {
      // On network error, try to return cached data
      if (_isNetworkError(e)) {
        try {
          final cachedTransactions = await localDataSource
              .getAccountTransactions(accountId, page: page);
          if (cachedTransactions.isNotEmpty) {
            return Result.success(PaginatedTransactionsResponse(
              transactions: cachedTransactions,
              hasMore: true, // Assume more when offline
            ));
          }
        } catch (_) {
          // Ignore cache errors
        }
        return Result.failure(const NetworkFailure());
      }

      return Result.failure(_mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<BeneficiaryModel>>> getBeneficiaries() async {
    try {
      final beneficiaries = await apiDataSource.getBeneficiaries();
      return Result.success(beneficiaries);
    } on DioException catch (e) {
      return Result.failure(_mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TransferResponseModel>> createTransfer({
    required String id,
    required double amount,
  }) async {
    try {
      final response = await apiDataSource.createTransfer(
        beneficiaryId: id,
        amount: amount,
      );
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(_mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TransferResponseModel>> confirmTransfer(
    String transferId,
  ) async {
    try {
      final response = await apiDataSource.confirmTransfer(transferId);
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(_mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<CardStatusResponseModel>> updateCardStatus({
    required String cardId,
    required String status,
  }) async {
    try {
      final response = await apiDataSource.updateCardStatus(cardId, status);
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(_mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveAccounts(List<AccountModel> accounts) async {
    try {
      await localDataSource.saveAccounts(accounts);
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCache() async {
    try {
      await localDataSource.clearAll();
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  /// Maps DioException to appropriate Failure type
  Failure _mapDioErrorToFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return const AuthenticationFailure();
        } else if (statusCode == 403) {
          return const AuthorizationFailure();
        } else if (statusCode == 404) {
          return const NotFoundFailure();
        } else {
          return ServerFailure(
            error.response?.data?['message'] ?? 'Server error',
            code: statusCode?.toString(),
          );
        }

      case DioExceptionType.cancel:
        return const UnknownFailure('Request cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('Invalid SSL certificate');

      case DioExceptionType.unknown:
      default:
        return UnknownFailure(error.message ?? 'Unknown error');
    }
  }

  /// Checks if the error is a network-related error
  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }
}
