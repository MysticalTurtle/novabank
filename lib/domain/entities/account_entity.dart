import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String alias;
  final String currency;
  final double availableBalance;
  final double ledgerBalance;

  const Account({
    required this.id,
    required this.alias,
    required this.currency,
    required this.availableBalance,
    required this.ledgerBalance,
  });

  @override
  List<Object?> get props => [
        id,
        alias,
        currency,
        availableBalance,
        ledgerBalance,
      ];

  @override
  String toString() {
    return 'Account{id: $id, alias: $alias, currency: $currency, '
        'availableBalance: $availableBalance, ledgerBalance: $ledgerBalance}';
  }
}