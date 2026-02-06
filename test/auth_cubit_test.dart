import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novabank/core/error/failures.dart';
import 'package:novabank/core/utils/result.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';
import 'package:novabank/ui/auth/cubit/auth_cubit.dart';

// Mock implementation of NovabankRepository
class MockNovabankRepository extends Mock implements NovabankRepository {}

void main() {
  late AuthCubit authCubit;
  late MockNovabankRepository mockRepository;

  setUp(() {
    mockRepository = MockNovabankRepository();
    authCubit = AuthCubit(repository: mockRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit -', () {
    test('initial state should be empty with initial status', () {
      expect(authCubit.state.status, AuthStatus.initial);
      expect(authCubit.state.errorMessage, isNull);
    });

    group('login -', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when login is successful with internet',
        build: () {
          // Simulate successful login with internet connection
          when(() => mockRepository.login())
              .thenAnswer((_) async => Result.success(null));
          return authCubit;
        },
        act: (cubit) => cubit.login(),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(status: AuthStatus.authenticated),
        ],
        verify: (_) {
          verify(() => mockRepository.login()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, error] when there is no internet connection',
        build: () {
          // Simulate no internet connection
          when(() => mockRepository.login()).thenAnswer(
            (_) async => Result.failure(
              const NoInternetFailure('No hay conexión a Internet'),
            ),
          );
          return authCubit;
        },
        act: (cubit) => cubit.login(),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            errorMessage: 'No hay conexión a Internet',
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.login()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, error] when network error occurs',
        build: () {
          // Simulate network error
          when(() => mockRepository.login()).thenAnswer(
            (_) async => Result.failure(
              const NetworkFailure('Network error occurred'),
            ),
          );
          return authCubit;
        },
        act: (cubit) => cubit.login(),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            errorMessage: 'Network error occurred',
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.login()).called(1);
        },
      );
    });

    group('checkAuthStatus -', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when user is already logged in',
        build: () {
          when(() => mockRepository.checkIsLoggedIn())
              .thenAnswer((_) async => true);
          return authCubit;
        },
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(status: AuthStatus.authenticated),
        ],
        verify: (_) {
          verify(() => mockRepository.checkIsLoggedIn()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, unauthenticated] when user is not logged in',
        build: () {
          when(() => mockRepository.checkIsLoggedIn())
              .thenAnswer((_) async => false);
          return authCubit;
        },
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(status: AuthStatus.unauthenticated),
        ],
        verify: (_) {
          verify(() => mockRepository.checkIsLoggedIn()).called(1);
        },
      );
    });

    group('logout -', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, unauthenticated] when logout is successful',
        build: () {
          when(() => mockRepository.logout())
              .thenAnswer((_) async => Result.success(null));
          return authCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(status: AuthStatus.unauthenticated),
        ],
        verify: (_) {
          verify(() => mockRepository.logout()).called(1);
        },
      );
    });
  });
}
