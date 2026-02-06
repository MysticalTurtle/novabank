import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/core/di_core.dart';
import 'package:novabank/data/models/account_model.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';
import 'package:novabank/ui/transactions/cubit/transactions_cubit.dart';
import 'package:novabank/ui/transactions/page/transactions_view.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key, required this.account});

  final AccountModel account;

  static const String routeName = '/transactions';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsCubit(
        repository: getIt<NovabankRepository>(),
        accountId: account.id,
      )..getTransactions(),
      child: TransactionsView(account: account),
    );
  }
}
