import 'package:novabank/domain/entities/account_entity.dart';

class AccountModel {
  final String id;
  final String alias;
  final String currency;
  final double availableBalance;
  final double ledgerBalance;

  AccountModel({
    required this.id,
    required this.alias,
    required this.currency,
    required this.availableBalance,
    required this.ledgerBalance,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      alias: json['alias'] as String,
      currency: json['currency'] as String,
      availableBalance: (json['available_balance'] as num).toDouble(),
      ledgerBalance: (json['ledger_balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alias': alias,
      'currency': currency,
      'available_balance': availableBalance,
      'ledger_balance': ledgerBalance,
    };
  }

  static List<AccountModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Account toDomain() {
    return Account(
      id: id,
      alias: alias,
      currency: currency,
      availableBalance: availableBalance,
      ledgerBalance: ledgerBalance,
    );
  }

  static List<Account> toDomainList(List<AccountModel> models) {
    return models.map((model) => model.toDomain()).toList();
  }
}
