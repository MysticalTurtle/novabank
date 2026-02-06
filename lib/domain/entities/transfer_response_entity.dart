import 'package:equatable/equatable.dart';

class TransferResponse extends Equatable {
  final String id;
  final String status;

  const TransferResponse({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        status,
      ];
}
