import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/core/di_core.dart';
import 'package:novabank/domain/repositories/novabank_repository.dart';
import 'package:novabank/ui/auth/auth_listener.dart';
import 'package:novabank/ui/auth/cubit/auth_cubit.dart';
import 'package:novabank/ui/auth/page/login_page.dart';
import 'package:novabank/ui/home/page/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await setupDiCore();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(repository: getIt<NovabankRepository>())..checkAuthStatus(),
      child: AuthListener(
        navigatorKey: navigatorKey,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'NovaBank',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const _SplashScreen(),
            LoginPage.routeName: (context) => const LoginPage(),
            HomePage.routeName: (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
