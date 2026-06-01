import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_money/core/api_client.dart';
import 'package:my_money/features/user/user_model.dart';

class UserRepository {
  final _dio = ApiClient().dio;

  // função pata buscar os dados do perfil do usuário
  Future<UserModel> obterPerfilUsuario() async {
    try {
      final response = await _dio.get("/users/me");

      var user = response.data["user"];

      return UserModel.fromJson(user);
    } on DioException catch (e) {
      print('Erro ao obter perfil do usuário: $e');
      throw Exception(
        "Falha ao obter perfil do usuário. Tente novamente mais tarde.",
      );
    }
  }

  // função para atualizar imagem do perfil do usuário
  Future<bool> atualizarImagemPerfil(File novaImagem) async {
    try {
      String fileName = novaImagem.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          novaImagem.path,
          filename: fileName,
        ),
      });

      await _dio.post("/users/upload-profile-image", data: formData);
      return true;
    } on DioException catch (e) {
      print('Erro ao atualizar imagem do perfil: $e');
      throw Exception(
        "Falha ao atualizar imagem do perfil. Tente novamente mais tarde.",
      );
    }
  }

  // função para buscar dados mínimos do perfil do usuário (nome e imagem)
  Future<UserModelMin> obterDadosMinPerfil() async {
    try {
      final response = await _dio.get("/users/data-min");
      var data = response.data;

      return UserModelMin.fromJson(data);
    } on DioException catch (e) {
      print('Erro ao obter dados mínimos do perfil: ${e.message}');
      throw Exception(
        "Falha ao obter dados mínimos do perfil. Tente novamente mais tarde.",
      );
    }
  }

  // função para excluir a conta do usuário
  Future<void> excluirConta() async {
    try {
      await _dio.delete("/users", data: {});
    } on DioException catch (e) {
      print('Erro ao excluir conta: $e');
      throw Exception("Falha ao excluir conta. Tente novamente mais tarde.");
    }
  }
}

// função para buscar imagem do perfil do usuário
Future<String> obterImagemPerfil() async {
  try {
    final response = await ApiClient().dio.get("/users/profile-image");
    return response.data["imageUrl"];
  } on DioException catch (e) {
    print('Erro ao obter imagem do perfil: $e');
    throw Exception(
      "Falha ao obter imagem do perfil. Tente novamente mais tarde.",
    );
  }
}
