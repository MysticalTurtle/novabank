import 'package:novabank/data/models/transaction_model.dart';

class PaginatedTransactionsResponse {
  final List<TransactionModel> transactions;
  final bool hasMore;

  PaginatedTransactionsResponse({
    required this.transactions,
    required this.hasMore,
  });

  factory PaginatedTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedTransactionsResponse(
      transactions: TransactionModel.fromJsonList(json['transactions'] as List),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'has_more': hasMore,
    };
  }
}
