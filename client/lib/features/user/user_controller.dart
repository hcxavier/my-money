import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_money/features/user/user_model.dart';
import 'package:my_money/features/user/user_repository.dart';

class UserController {
  final _repository = UserRepository();

  // estados:
  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  // função de obter perfil do usuário
  Future<UserModel> obterPerfilUsuario() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      return await _repository.obterPerfilUsuario();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função de obter dados mínimos do perfil do usuário (nome e imagem)
  Future<UserModelMin> obterDadosMinPerfil() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      return await _repository.obterDadosMinPerfil();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função de atualizar imagem do perfil do usuário
  Future<bool> atualizarImagemPerfil(File novaImagem) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      await _repository.atualizarImagemPerfil(novaImagem);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função para buscar imagem de perfil
  Future<String> obterImagemPerfil() async {
    isLoading.value = true;
    try {
      final user = await UserController().obterPerfilUsuario();
      return user.imageUrl;
    } catch (e) {
      print('Erro ao obter imagem do perfil: $e');
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  // função para excluir conta
  Future<bool> excluirConta() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      await _repository.excluirConta();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
