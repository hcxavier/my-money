import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_money/core/api_client.dart';
import 'package:my_money/features/auth/auth_model.dart';

class AuthRepository {
  final _dio = ApiClient().dio;
  final _appAuth = const FlutterAppAuth();

  // fluxo OAuth2 + PKCE
  Future<AuthorizationTokenResponse?> realizarLoginOAuth2() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          dotenv.get("CLIENT_ID"),
          'com.example.mymoney://callback',
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: "${dotenv.get("API_URL")}/o/authorize/",
            tokenEndpoint: "${dotenv.get("API_URL")}/o/token/",
          ),
          scopes: ['read', 'write', 'openid'],
          allowInsecureConnections: true
        ),
      );
      return result;
    } catch (e) {
      print('Erro no login OAuth2: $e');
      throw Exception("Falha na autenticação. Tente novamente.");
    }
  }

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
