import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';

class BuildTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;

  const BuildTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    isVisible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: CoresGlobal().labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && !isVisible,
          style: const TextStyle(color: Colors.white),
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: CoresGlobal().hintColor, fontSize: 15),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: CoresGlobal().iconColor,
              size: 22,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: CoresGlobal().iconColor,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  )
                : null,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CoresGlobal().borderColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CoresGlobal().primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
