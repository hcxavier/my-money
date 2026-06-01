import 'package:flutter/material.dart';
import 'package:my_money/core/token_service.dart';
import 'package:my_money/features/auth/auth_repository.dart';

class AuthController {
  final AuthRepository _repository = AuthRepository();
  final TokenService _tokenService = TokenService();

  // estados:
  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  // função de validação de token
  Future<bool> validarToken() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final isValid = await _repository.validarToken();
      return isValid;
    } finally {
      isLoading.value = false;
    }
  }

  // Função de login
  Future<bool> realizarLoginEmailSenha(String email, String senha) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final authModelLogin = await _repository.realizarLoginEmailSenha(
        email,
        senha,
      );

      if (authModelLogin.token.isNotEmpty) {
        await _tokenService.salvarToken(authModelLogin.token);
        return true;
      }

      errorMessage.value = "Token de autenticação vazio recebido do servidor.";
      throw Exception("Token de autenticação vazio recebido do servidor.");
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Função de registro
  Future<bool> realizarRegistroEmailSenha(
    String name,
    String email,
    String senha,
    String confirmPassword,
  ) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (senha != confirmPassword) {
        errorMessage.value = "As senhas não coincidem.";
        throw Exception("As senhas não coincidem.");
      }

      final authModelLogin = await _repository.realizarRegistroEmailSenha(
        name,
        email,
        senha,
      );

      if (authModelLogin.token.isNotEmpty) {
        await _tokenService.salvarToken(authModelLogin.token);
        return true;
      }

      errorMessage.value = "Token de autenticação vazio recebido do servidor.";
      throw Exception("Token de autenticação vazio recebido do servidor.");
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
