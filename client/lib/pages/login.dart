import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_login.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
import 'package:my_money/components/ui/nav_auth.dart';
import 'package:my_money/features/auth/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  LoginPage({super.key});

  Future<void> _handleLogin(
    BuildContext context,
    String email,
    String password,
  ) async {
    final success = await _authController.realizarLoginEmailSenha(
      email,
      password,
    );

    if (!context.mounted) return;

    if (success) {
      CustomSnackBar.show(
        context: context,
        message: "Login realizado com sucesso!",
      );
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      CustomSnackBar.show(
        context: context,
        message: _authController.errorMessage.value ?? "Erro ao fazer login.",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF1E1E1E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const NavBarAuth(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 48),
          LoginForm(
            onLoginPressed: (email, password) async {
              await _handleLogin(context, email, password);
            },
          ),

          const Spacer(),
          const AuthActionButton(
            label: "Ainda não tem uma conta?",
            buttonLabel: "Cadastre-se",
            routeName: "/register",
          ),
        ],
      ),
    );
  }
}
