import 'package:novabank/domain/entities/transaction_entity.dart';

class TransactionModel {
  final String date;
  final String id;
  final double amount;
  final String description;
  final String type;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'description': description,
      'type': type,
    };
  }

  static List<TransactionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Convert model to domain entity
  Transaction toDomain() {
    return Transaction(
      id: id,
      date: date,
      amount: amount,
      description: description,
      type: type,
    );
  }

  /// Convert list of models to domain entities
  static List<Transaction> toDomainList(List<TransactionModel> models) {
    return models.map((model) => model.toDomain()).toList();
  }
}
