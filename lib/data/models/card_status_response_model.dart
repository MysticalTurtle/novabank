import 'package:novabank/domain/entities/card_status_response_entity.dart';

class CardStatusResponseModel {
  final String status;

  CardStatusResponseModel({
    required this.status,
  });

  factory CardStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return CardStatusResponseModel(
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }

  /// Convert model to domain entity
  CardStatusResponse toDomain() {
    return CardStatusResponse(
      status: status,
    );
  }
}
