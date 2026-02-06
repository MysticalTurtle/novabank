import 'package:flutter/material.dart';
import 'package:novabank/data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type.toLowerCase() == 'credit';
    final amountColor = isCredit ? Colors.green : Colors.red;
    final amountPrefix = isCredit ? '+' : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: isCredit ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: amountColor,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          transaction.date,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Text(
          '$amountPrefix\$${transaction.amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: amountColor,
          ),
        ),
      ),
    );
  }
}
