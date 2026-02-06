import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/core/di_core.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';
import 'package:novabank/ui/home/cubit/home_cubit.dart';
import 'package:novabank/ui/home/page/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(repository: getIt<NovabankRepository>())..getAccounts(),
      child: const HomeView(),
    );
  }
}
