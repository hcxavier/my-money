import 'package:dio/dio.dart';
import 'package:my_money/core/api_client.dart';
import 'package:my_money/features/transactions/transactions_model.dart';

class TransactionsRepository {
  final Dio _dio = ApiClient().dio;

  // função para buscar métricas globais
  Future<TransactionsMetrics> obterMetricasGlobais() async {
    try {
      final response = await _dio.get("/metrics");
      final data = response.data;

      // Tratamento para valores nulos em datas
      data['entradas'] ??= {};
      data['saidas'] ??= {};
      data['total'] ??= {};

      data['entradas']['lastDate'] ??= '';
      data['saidas']['lastDate'] ??= '';
      data['total']['firstDate'] ??= '';
      data['total']['lastDate'] ??= '';

      var metricas = TransactionsMetrics.fromJson(data);
      return metricas;
    } on DioException catch (e) {
      print('Erro ao obter métricas globais: \\${e.message}');
      throw Exception(
        "Falha ao obter métricas globais. Tente novamente mais tarde.",
      );
    }
  }

  // função para buscar categorias
  Future<List<CategoryModel>> obterCategorias() async {
    try {
      final response = await _dio.get("/transactions/categories");

      var categorias = (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return categorias;
    } on DioException catch (e) {
      print('Erro ao obter categorias: ${e.message}');
      throw Exception("Falha ao obter categorias. Tente novamente mais tarde.");
    }
  }

  // função para buscar transações
  Future<List<TransactionModel>> obterTransacoes({
    required TransactionsFilters filters,
  }) async {
    try {
      final response = await _dio.get(
        "/transactions",
        queryParameters: filters.toQueryParameters(),
      );
      final data = response.data;
      if (data is List && data.isEmpty) {
        return <TransactionModel>[];
      }
      return (data as List).map((e) => TransactionModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print('Erro ao obter transações: \\${e.message}');
      throw Exception("Falha ao obter transações. Tente novamente mais tarde.");
    }
  }

  // função para criar nova transação
  Future<bool> criarTransacao({
    required String title,
    required double amount,
    required String type,
    required int categoryId,
  }) async {
    try {
      await _dio.post(
        "/transactions",
        data: {
          "title": title,
          "amount": amount,
          "type": type,
          "categoryId": categoryId,
        },
      );
      return true;
    } on DioException catch (e) {
      print('Erro ao criar transação: ${e.message}');
      throw Exception("Falha ao criar transação. Tente novamente mais tarde.");
    }
  }

  // função para excluir uma transação
  Future<bool> excluirTransacao(int id) async {
    try {
      await _dio.delete("/transactions/$id", data: {});
      return true;
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 404) {
        print('Transação não encontrada para exclusão: ${e.message}');
        throw Exception(
          "Transação não encontrada. Ela pode já ter sido excluída.",
        );
      }

      print('Erro ao excluir transação: ${e.message}');
      throw Exception(
        "Falha ao excluir transação. Tente novamente mais tarde.",
      );
    }
  }

  // função para editar uma transação
  Future<bool> editarTransacao({
    required int id,
    required String title,
    required double amount,
    required String type,
    required int categoryId,
  }) async {
    try {
      await _dio.put(
        "/transactions/$id",
        data: {
          "title": title,
          "amount": amount,
          "type": type,
          "categoryId": categoryId,
        },
      );
      return true;
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 404) {
        print('Transação não encontrada para edição: ${e.message}');
        throw Exception(
          "Transação não encontrada. Ela pode já ter sido excluída.",
        );
      }
      print('Erro ao editar transação: ${e.message}');
      throw Exception("Falha ao editar transação. Tente novamente mais tarde.");
    }
  }
}
