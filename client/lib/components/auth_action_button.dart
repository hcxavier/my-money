import 'package:flutter/material.dart';

class AuthActionButton extends StatelessWidget {
  final String label;
  final String buttonLabel;
  final String routeName;

  const AuthActionButton({
    super.key,
    required this.label,
    required this.buttonLabel,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00875F); // Verde
    const Color textColor = Colors.white54;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // TEXTO DE CHAMADA
          Text(label, style: const TextStyle(color: textColor, fontSize: 15)),

          const SizedBox(height: 16),

          // BOTÃO CADASTRAR (Outlined)
          SizedBox(
            width: double.infinity,
            height: 56, // Mesma altura do botão Logar
            child: OutlinedButton(
              onPressed: () {
                // Lógica de autenticação vai aqui
                Navigator.pushReplacementNamed(context, routeName);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ), // Borda verde
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    6,
                  ), // Mesmo arredondamento
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    buttonLabel,
                    style: const TextStyle(
                      color: primaryColor, // Texto verde
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: primaryColor, // Ícone verde
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
