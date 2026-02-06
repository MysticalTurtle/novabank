import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/core/di_core.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';
import 'package:novabank/ui/transfer/cubit/transfer_cubit.dart';
import 'package:novabank/ui/transfer/page/transfer_view.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  static const String routeName = '/transfer';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferCubit(
        repository: getIt<NovabankRepository>(),
      )..getBeneficiaries(),
      child: const TransferView(),
    );
  }
}
