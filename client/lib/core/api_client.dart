import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_money/core/token_service.dart';

class ApiClient {
  late Dio dio;
  final _appAuth = const FlutterAppAuth();
  final _tokenService = TokenService();

  ApiClient() {
    BaseOptions options = BaseOptions(
      baseUrl: dotenv.get("API_URL"),
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {"Content-Type": "application/json"},
    );

    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.recuperarAccessToken();
          if (token != null) {
            options.headers["Authorization"] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await _tokenService.recuperarRefreshToken();
            
            if (refreshToken != null) {
              try {
                final result = await _appAuth.token(TokenRequest(
                  dotenv.get("CLIENT_ID"),
                  'my.money.app://oauth-callback',
                  refreshToken: refreshToken,
                  serviceConfiguration: AuthorizationServiceConfiguration(
                    authorizationEndpoint: "${dotenv.get("API_URL")}/o/authorize/",
                    tokenEndpoint: "${dotenv.get("API_URL")}/o/token/",
                  ),
                ));

                if (result != null && result.accessToken != null) {
                  await _tokenService.salvarTokens(
                    result.accessToken!,
                    result.refreshToken,
                  );

                  // Repetir a requisição original com o novo token
                  final requestOptions = e.requestOptions;
                  requestOptions.headers["Authorization"] =
                      'Bearer ${result.accessToken}';

                  final response = await dio.fetch(requestOptions);
                  return handler.resolve(response);
                }
              } catch (err) {
                print("Erro ao renovar token: $err");
                await _tokenService.removerTokens();
                // Aqui você poderia disparar um evento para redirecionar para o login
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  }
}
