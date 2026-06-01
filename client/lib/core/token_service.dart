import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = "jwt_token";

  // Função de salvar o token
  Future<void> salvarToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Função de recuperar o token
  Future<String?> recuperarToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Função de remover o token
  Future<void> removerToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
