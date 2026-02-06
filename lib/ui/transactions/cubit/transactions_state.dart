part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, error }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionModel> transactions;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionModel>? transactions,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        errorMessage,
        currentPage,
        hasReachedMax,
      ];
}
