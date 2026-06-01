import 'package:dio/dio.dart';
import 'package:my_money/core/api_client.dart';
import 'package:my_money/features/auth/auth_model.dart';

class AuthRepository {
  final _dio = ApiClient().dio;

  // função de validação de token
  Future<bool> validarToken() async {
    try {
      final response = await _dio.get("/auth/validate");

      if (response.data) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Erro ao validar token: ${e.message}');
      return false;
    }
  }

  // função de registro
  Future<AuthModelLogin> realizarRegistroEmailSenha(
    String name,
    String email,
    String senha,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/register",
        data: {"name": name, "email": email, "password": senha},
      );
      return AuthModelLogin.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          "Dados inválidos. Por favor, verifique as informações fornecidas.",
        );
      } else if (e.response?.statusCode == 409) {
        throw Exception(
          "Email já registrado. Por favor, use outro email ou faça login.",
        );
      } else {
        print('Erro no servidor: ${e.message}');
        throw Exception(
          "Falha ao se registrar. Erro no servidor. Tente novamente mais tarde.",
        );
      }
    }
  }

  Future<AuthModelLogin> realizarLoginEmailSenha(
    String email,
    String senha,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": senha},
      );

      return AuthModelLogin.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        throw Exception(
          "Credenciais inválidas. Por favor, verifique seu email e senha.",
        );
      } else {
        print('Erro no servidor: ${e.message}');
        throw Exception(
          "Falha ao fazer login. Erro no servidor. Tente novamente mais tarde.",
        );
      }
    }
  }
}
