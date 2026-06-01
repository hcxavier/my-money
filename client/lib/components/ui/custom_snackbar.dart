import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    final Color strokeColor = isError
        ? const Color(0xFFF75A68)
        : const Color(0xFF00875F);
    final IconData icon = isError
        ? Icons.error_outline
        : Icons.check_circle_outline;

    showTopSnackBar(
      Overlay.of(context),
      Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF202024),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: strokeColor, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: strokeColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFE1E1E6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      displayDuration: const Duration(seconds: 3),
    );
  }
}
