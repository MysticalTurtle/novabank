import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/ui/auth/cubit/auth_cubit.dart';
import 'package:novabank/ui/auth/page/login_page.dart';
import 'package:novabank/ui/home/page/home_page.dart';

class AuthListener extends StatelessWidget {
  const AuthListener({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final navigator = navigatorKey?.currentState ?? Navigator.of(context);
        if (state.status == AuthStatus.authenticated) {
          navigator.pushReplacementNamed(HomePage.routeName);
        } else if (state.status == AuthStatus.unauthenticated) {
          navigator.pushReplacementNamed(LoginPage.routeName);
        }
      },
      child: child,
    );
  }
}
