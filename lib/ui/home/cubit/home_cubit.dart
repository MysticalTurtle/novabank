import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novabank/data/models/account_model.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final NovabankRepository _repository;

  HomeCubit({required NovabankRepository repository})
      : _repository = repository,
        super(const HomeState());

  /// Fetch accounts from repository
  Future<void> getAccounts() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _repository.getAccounts();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: HomeStatus.error,
          errorMessage: failure.message,
        ));
      },
      (accounts) {
        emit(state.copyWith(
          status: HomeStatus.success,
          accounts: accounts,
        ));
      },
    );
  }
}
