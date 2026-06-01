class TransactionModel {
  final int id;
  final String title;
  final double amount;
  final String createdAt;
  final String type;
  final CategoryModel category;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.type,
    required this.category,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      type: json['type'] as String,
      category: CategoryModel.fromJson(json['category']),
    );
  }
}

class TransactionsMetrics {
  final EntradaSaidaMetric entradas;
  final EntradaSaidaMetric saidas;
  final TotalMetric total;

  TransactionsMetrics({
    required this.entradas,
    required this.saidas,
    required this.total,
  });

  factory TransactionsMetrics.fromJson(Map<String, dynamic> json) {
    return TransactionsMetrics(
      entradas: EntradaSaidaMetric.fromJson(json['entradas']),
      saidas: EntradaSaidaMetric.fromJson(json['saidas']),
      total: TotalMetric.fromJson(json['total']),
    );
  }
}

class EntradaSaidaMetric {
  final double total;
  final String lastDate;

  EntradaSaidaMetric({required this.total, required this.lastDate});

  factory EntradaSaidaMetric.fromJson(Map<String, dynamic> json) {
    return EntradaSaidaMetric(
      total: (json['total'] as num).toDouble(),
      lastDate: json['lastDate'] as String,
    );
  }
}

class TotalMetric {
  final double balance;
  final String firstDate;
  final String lastDate;

  TotalMetric({
    required this.balance,
    required this.firstDate,
    required this.lastDate,
  });

  factory TotalMetric.fromJson(Map<String, dynamic> json) {
    return TotalMetric(
      balance: (json['balance'] as num).toDouble(),
      firstDate: json['firstDate'] as String,
      lastDate: json['lastDate'] as String,
    );
  }
}

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'] as int, name: json['name'] as String);
  }
}

class TransactionsFilters {
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final List<int>? categoriasId;
  final List<String>? tipos;
  final String? search;

  TransactionsFilters({
    this.dataInicio,
    this.dataFim,
    this.categoriasId,
    this.tipos,
    this.search,
  });

  bool get isEmpty =>
      dataInicio == null &&
      dataFim == null &&
      categoriasId == null &&
      tipos == null &&
      search == null;

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};
    if (dataInicio != null) {
      params['dataInicio'] = dataInicio!.toIso8601String();
    }
    if (dataFim != null) {
      params['dataFim'] = dataFim!.toIso8601String();
    }
    if (categoriasId != null) {
      params['categoriasId'] = categoriasId;
    }
    if (tipos != null) {
      params['tipos'] = tipos;
    }
    if (search != null) {
      params['search'] = search;
    }
    return params;
  }
}
