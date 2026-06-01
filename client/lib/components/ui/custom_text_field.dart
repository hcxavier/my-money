import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00875F);
    const Color labelColor = Colors.white54;
    const Color iconColor = Colors.white54;
    const Color borderColor = Colors.white12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(color: readOnly ? Colors.white54 : Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, color: iconColor, size: 22),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : borderColor,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : primaryColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
