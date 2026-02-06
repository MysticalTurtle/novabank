import 'package:equatable/equatable.dart';

class Beneficiary extends Equatable {
  final String id;
  final String name;
  final String accountNumber;

  const Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        accountNumber,
      ];

  @override
  String toString() {
    return 'Beneficiary{id: $id, name: $name, accountNumber: $accountNumber}';
  }
}
