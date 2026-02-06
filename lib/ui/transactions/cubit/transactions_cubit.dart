import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novabank/data/models/transaction_model.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final NovabankRepository _repository;
  final String accountId;

  TransactionsCubit({
    required NovabankRepository repository,
    required this.accountId,
  })  : _repository = repository,
        super(const TransactionsState());

  /// Fetch transactions for the first page
  Future<void> getTransactions() async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    final result = await _repository.getAccountTransactions(
      accountId,
      page: 1,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TransactionsStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: TransactionsStatus.success,
          transactions: response.transactions,
          currentPage: 1,
          hasReachedMax: !response.hasMore,
        ));
      },
    );
  }

  /// Load more transactions (next page)
  Future<void> loadMore() async {
    if (state.hasReachedMax) return;

    final nextPage = state.currentPage + 1;

    final result = await _repository.getAccountTransactions(
      accountId,
      page: nextPage,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TransactionsStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: TransactionsStatus.success,
          transactions: [...state.transactions, ...response.transactions],
          currentPage: nextPage,
          hasReachedMax: !response.hasMore,
        ));
      },
    );
  }
}
