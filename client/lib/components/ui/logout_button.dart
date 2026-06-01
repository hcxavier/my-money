import 'package:flutter/material.dart';
import 'package:my_money/core/token_service.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';

class LogoutButton extends StatelessWidget {
  final Color borderColor;

  const LogoutButton({super.key, required this.borderColor});

  Future<void> fazerLogout(BuildContext context) async {
    final tokenService = TokenService();

    await tokenService.removerToken();

    if (context.mounted) {
      CustomSnackBar.show(
        context: context,
        message: 'Logout realizado com sucesso!',
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {
          fazerLogout(context);
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Sair da conta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
