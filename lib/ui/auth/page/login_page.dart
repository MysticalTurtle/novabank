import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/ui/auth/cubit/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Login failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or App Name
                    const Icon(
                      Icons.account_balance,
                      size: 100,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'NovaBank',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Secure Banking Experience',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 64),
                    
                    // Login Button
                    if (state.status == AuthStatus.loading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().login();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.login),
                            SizedBox(width: 8),
                            Text(
                              'Sign In with OAuth',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Information text
                    Text(
                      'Secure authentication with OAuth 2.0 + PKCE',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
