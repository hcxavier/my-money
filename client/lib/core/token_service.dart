import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storage = const FlutterSecureStorage();
  
  final String _accessTokenKey = "access_token";
  final String _refreshTokenKey = "refresh_token";
  final String _idTokenKey = "id_token";

  // Salvar tokens
  Future<void> salvarTokens(String accessToken, String? refreshToken, {String? idToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
    if (idToken != null) {
      await _storage.write(key: _idTokenKey, value: idToken);
    }
  }

  // Recuperar access token
  Future<String?> recuperarAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Recuperar refresh token
  Future<String?> recuperarRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Recuperar ID token
  Future<String?> recuperarIdToken() async {
    return await _storage.read(key: _idTokenKey);
  }

  // Remover tokens
  Future<void> removerTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _idTokenKey);
  }
}
