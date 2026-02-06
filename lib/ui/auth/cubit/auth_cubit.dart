import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final NovabankRepository _repository;

  AuthCubit({required NovabankRepository repository})
    : _repository = repository,
      super(AuthState.empty());

  /// Check if user is already logged in
  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final isLoggedIn = await _repository.checkIsLoggedIn();

    if (isLoggedIn) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Perform login via OAuth + PKCE flow
  Future<void> login() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.login();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.authenticated));
      },
    );
  }

  /// Logout and clear session
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _repository.logout();

    result.fold(
      (failure) {
        // Even on failure, transition to unauthenticated
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
    );
  }
}
