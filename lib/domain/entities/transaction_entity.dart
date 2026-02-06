import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String date;
  final double amount;
  final String description;
  final String type;

  const Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        amount,
        description,
        type,
      ];
}
