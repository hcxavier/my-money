import 'package:flutter/material.dart';
import 'package:my_money/features/transactions/transactions_model.dart';
import 'package:my_money/features/transactions/transactions_repository.dart';

class TransactionsController {
  final TransactionsRepository _repository = TransactionsRepository();

  // estados:
  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);
  final metricas = ValueNotifier<TransactionsMetrics?>(null);
  final categorias = ValueNotifier<List<CategoryModel>>([]);
  final transacoes = ValueNotifier<List<TransactionModel>>([]);

  // função de busca de métricas
  Future<TransactionsMetrics> obterMetricasGlobais() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final metricas = await _repository.obterMetricasGlobais();
      this.metricas.value = metricas;
      return metricas;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função de busca de categorias
  Future<List<CategoryModel>> obterCategorias() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final categorias = await _repository.obterCategorias();
      return categorias;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função de busca de transações
  Future<List<TransactionModel>> obterTransacoes({
    required TransactionsFilters filters,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final transacoes = await _repository.obterTransacoes(filters: filters);
      this.transacoes.value = transacoes;
      return transacoes;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função de criação de nova transação
  Future<bool> criarTransacao({
    required String title,
    required double amount,
    required String type,
    required int categoryId,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (title.isEmpty ||
          amount <= 0 ||
          (type != 'entrada' && type != 'saida')) {
        throw Exception(
          "Dados inválidos. Verifique as informações e tente novamente.",
        );
      }

      final sucesso = await _repository.criarTransacao(
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
      );
      return sucesso;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // excluir transação
  Future<bool> excluirTransacao(int id) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final sucesso = await _repository.excluirTransacao(id);
      return sucesso;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // função de edição de transação
  Future<bool> editarTransacao({
    required int id,
    required String title,
    required double amount,
    required String type,
    required int categoryId,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (title.isEmpty ||
          amount <= 0 ||
          (type != 'entrada' && type != 'saida')) {
        errorMessage.value =
            "Dados inválidos. Verifique as informações e tente novamente.";
        throw Exception(
          "Dados inválidos. Verifique as informações e tente novamente.",
        );
      }

      final sucesso = await _repository.editarTransacao(
        id: id,
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
      );
      return sucesso;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
