import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novabank/data/models/models.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';

part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  final NovabankRepository _repository;

  TransferCubit({required NovabankRepository repository})
      : _repository = repository,
        super(const TransferState());

  /// Fetch beneficiaries
  Future<void> getBeneficiaries() async {
    emit(state.copyWith(status: TransferStatus.loading));

    final result = await _repository.getBeneficiaries();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TransferStatus.error,
          errorMessage: failure.message,
        ));
      },
      (beneficiaries) {
        emit(state.copyWith(
          status: TransferStatus.initial,
          beneficiaries: beneficiaries,
        ));
      },
    );
  }

  void selectBeneficiary(BeneficiaryModel beneficiary) {
    emit(state.copyWith(selectedBeneficiary: beneficiary));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  Future<void> createTransfer() async {
    if (state.selectedBeneficiary == null || state.amount == null) {
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage: 'Please select a beneficiary and enter an amount',
      ));
      return;
    }

    emit(state.copyWith(status: TransferStatus.loading));

    final result = await _repository.createTransfer(
      id: state.selectedBeneficiary!.id,
      amount: state.amount!,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TransferStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: TransferStatus.success,
          transferId: response.id,
        ));
      },
    );
  }

  /// Confirm transfer
  Future<void> confirmTransfer() async {
    if (state.transferId == null) {
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage: 'No transfer to confirm',
      ));
      return;
    }

    emit(state.copyWith(status: TransferStatus.confirming));

    final result = await _repository.confirmTransfer(state.transferId!);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TransferStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(status: TransferStatus.completed));
      },
    );
  }
}
