import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_login.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
import 'package:my_money/components/ui/nav_auth.dart';
import 'package:my_money/features/auth/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController;

  LoginPage({
    super.key,
    AuthController? authController,
  }) : _authController = authController ?? AuthController();

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

  Future<void> _handleOAuth2Login(BuildContext context) async {
    final success = await _authController.realizarLoginOAuth2();

    if (!context.mounted) return;

    if (success) {
      CustomSnackBar.show(
        context: context,
        message: "Login OAuth2 realizado com sucesso!",
      );
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      CustomSnackBar.show(
        context: context,
        message: _authController.errorMessage.value ?? "Erro no login OAuth2.",
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => _handleOAuth2Login(context),
                icon: const Icon(Icons.security, color: Colors.white),
                label: const Text(
                  "Entrar com OAuth2",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00875F)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
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
