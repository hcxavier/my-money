import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_register.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
import 'package:my_money/components/ui/nav_auth.dart';
import 'package:my_money/features/auth/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  RegisterPage({super.key});

  Future<void> _handleRegister(
    BuildContext context,
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final success = await _authController.realizarRegistroEmailSenha(
      name,
      email,
      password,
      confirmPassword,
    );

    if (!context.mounted) return;

    if (success) {
      CustomSnackBar.show(
        context: context,
        message: "Registro realizado com sucesso!",
      );
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      CustomSnackBar.show(
        context: context,
        message:
            _authController.errorMessage.value ?? "Erro ao fazer registro.",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CoresGlobal().backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: NavBarAuth(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 6),
          RegisterForm(
            onRegisterPressed: (name, email, password, confirmPassword) async {
              await _handleRegister(
                context,
                name,
                email,
                password,
                confirmPassword,
              );
            },
          ),

          const Spacer(),

          const AuthActionButton(
            label: "já tem uma conta?",
            buttonLabel: "Acessar",
            routeName: "/login",
          ),
        ],
      ),
    );
  }
}
