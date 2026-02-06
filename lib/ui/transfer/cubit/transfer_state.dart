part of 'transfer_cubit.dart';

enum TransferStatus { initial, loading, success, error, confirming, completed }

class TransferState extends Equatable {
  final TransferStatus status;
  final List<BeneficiaryModel> beneficiaries;
  final BeneficiaryModel? selectedBeneficiary;
  final double? amount;
  final String? transferId;
  final String? errorMessage;

  const TransferState({
    this.status = TransferStatus.initial,
    this.beneficiaries = const [],
    this.selectedBeneficiary,
    this.amount,
    this.transferId,
    this.errorMessage,
  });

  TransferState copyWith({
    TransferStatus? status,
    List<BeneficiaryModel>? beneficiaries,
    BeneficiaryModel? selectedBeneficiary,
    double? amount,
    String? transferId,
    String? errorMessage,
  }) {
    return TransferState(
      status: status ?? this.status,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
      amount: amount ?? this.amount,
      transferId: transferId ?? this.transferId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        beneficiaries,
        selectedBeneficiary,
        amount,
        transferId,
        errorMessage,
      ];
}
