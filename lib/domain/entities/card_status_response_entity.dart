import 'package:equatable/equatable.dart';

class CardStatusResponse extends Equatable {
  final String status;

  const CardStatusResponse({
    required this.status,
  });

  @override
  List<Object?> get props => [status];

  @override
  String toString() {
    return 'CardStatusResponse{status: $status}';
  }
}
