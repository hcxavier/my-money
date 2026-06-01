import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/ui/build_text_field.dart';

class RegisterForm extends StatefulWidget {
  final Future<void> Function(
    String name,
    String email,
    String password,
    String confirmPassword,
  )
  onRegisterPressed;

  const RegisterForm({super.key, required this.onRegisterPressed});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onRegisterPressed(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BuildTextField(
            label: 'NOME',
            hint: 'Seu nome completo',
            prefixIcon: Icons.person_outline,
            controller: _nameController,
            keyboardType: TextInputType.name,
          ),

          BuildTextField(
            label: 'EMAIL',
            hint: 'mail@exemplo.br',
            prefixIcon: Icons.mail_outline,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),

          BuildTextField(
            label: 'SENHA',
            hint: 'Sua senha',
            prefixIcon: Icons.lock_outline,
            controller: _passwordController,
            isPassword: true,
          ),

          BuildTextField(
            label: 'CONFIRMAR SENHA',
            hint: 'Confirme sua senha',
            prefixIcon: Icons.lock_outline,
            controller: _confirmPasswordController,
            isPassword: true,
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed:
                  (_nameController.text.trim().isEmpty ||
                      _emailController.text.trim().isEmpty ||
                      _passwordController.text.trim().isEmpty ||
                      _confirmPasswordController.text.trim().isEmpty ||
                      _isLoading)
                  ? null
                  : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGlobal().primaryColor,
                disabledBackgroundColor: CoresGlobal().primaryColor.withOpacity(
                  0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Registrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
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
