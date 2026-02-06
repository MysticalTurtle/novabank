import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/data/models/account_model.dart';
import 'package:novabank/ui/transactions/cubit/transactions_cubit.dart';
import 'package:novabank/ui/transactions/widgets/transaction_tile.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key, required this.account});

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.alias),
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state.status == TransactionsStatus.loading &&
              state.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransactionsStatus.error &&
              state.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<TransactionsCubit>().getTransactions();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('No transactions available'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<TransactionsCubit>().getTransactions(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.transactions.length + 1,
              itemBuilder: (context, index) {
                if (index == state.transactions.length) {
                  return _buildLoadMoreButton(context, state);
                }
                final transaction = state.transactions[index];
                return TransactionTile(transaction: transaction);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, TransactionsState state) {
    if (state.hasReachedMax) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No more transactions',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: TextButton(
          onPressed: () {
            context.read<TransactionsCubit>().loadMore();
          },
          child: const Text('Cargar más...'),
        ),
      ),
    );
  }
}
