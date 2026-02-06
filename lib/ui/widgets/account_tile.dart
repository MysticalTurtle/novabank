import 'package:flutter/material.dart';
import 'package:novabank/data/models/account_model.dart';
import 'package:novabank/ui/transactions/page/transactions_page.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({super.key, required this.account});

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TransactionsPage(account: account),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.account_balance, color: Colors.blue.shade700),
        ),
        title: Text(
          account.alias,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'ID: ${account.id}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${account.currency} ${account.availableBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Available',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
