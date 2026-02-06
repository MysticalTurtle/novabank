import 'package:novabank/domain/entities/transfer_response_entity.dart';

class TransferResponseModel {
  final String id;
  final String status;

  TransferResponseModel({
    required this.id,
    required this.status,
  });

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    return TransferResponseModel(
      id: json['id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }

  /// Convert model to domain entity
  TransferResponse toDomain() {
    return TransferResponse(
      id: id,
      status: status,
    );
  }
}
