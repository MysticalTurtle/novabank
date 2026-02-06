import 'package:novabank/domain/entities/beneficiary_entity.dart';

class BeneficiaryModel {
  final String id;
  final String name;
  final String accountNumber;

  BeneficiaryModel({
    required this.id,
    required this.name,
    required this.accountNumber,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      accountNumber: json['account_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'account_number': accountNumber,
    };
  }

  static List<BeneficiaryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => BeneficiaryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Convert model to domain entity
  Beneficiary toDomain() {
    return Beneficiary(
      id: id,
      name: name,
      accountNumber: accountNumber,
    );
  }

  /// Convert list of models to domain entities
  static List<Beneficiary> toDomainList(List<BeneficiaryModel> models) {
    return models.map((model) => model.toDomain()).toList();
  }
}
