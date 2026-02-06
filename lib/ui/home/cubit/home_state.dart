part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.accounts = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final List<AccountModel> accounts;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<AccountModel>? accounts,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accounts, errorMessage];
}
