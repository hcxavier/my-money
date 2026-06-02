import 'package:dio/dio.dart';
import 'package:my_money/core/token_service.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.0.104:8000/",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {"Content-Type": "application/json"},
    );

    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // pegar o token antes da requisição ser enviada
          final tokenService = TokenService();
          final token = await tokenService.recuperarToken();

          if (token == null) {
            // TODO: lidar com a ausência do token, talvez redirecionar para login
          }

          options.headers["Authorization"] = 'Bearer $token';
          return handler.next(options);
        },

        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // TODO: lidar com token expirado ou inválido, talvez redirecionar para login
          }

          return handler.next(e);
        },
      ),
    );
  }
}
