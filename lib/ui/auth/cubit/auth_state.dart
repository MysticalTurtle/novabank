part of 'auth_cubit.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.errorMessage,
  });

  factory AuthState.empty() => AuthState(status: AuthStatus.initial);

  final AuthStatus status;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
