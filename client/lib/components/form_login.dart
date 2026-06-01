import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/ui/build_text_field.dart';

class LoginForm extends StatefulWidget {
  final Future<void> Function(String email, String password) onLoginPressed;

  const LoginForm({super.key, required this.onLoginPressed});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onLoginPressed(
        _emailController.text.trim(),
        _passwordController.text.trim(),
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
            label: 'EMAIL',
            hint: 'Digite seu email',
            prefixIcon: Icons.mail_outline,
            controller: _emailController,
          ),
          const SizedBox(height: 32),

          BuildTextField(
            label: 'SENHA',
            hint: 'Digite sua senha',
            prefixIcon: Icons.lock_outline,
            controller: _passwordController,
            isPassword: true,
          ),

          const SizedBox(height: 40),

          // BOTÃO LOGAR
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed:
                  (_emailController.text.trim().isNotEmpty &&
                      _passwordController.text.trim().isNotEmpty &&
                      !_isLoading)
                  ? _handleLogin
                  : null,
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
                          'Logar',
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
