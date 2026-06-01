import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/features/transactions/transactions_model.dart';
import 'package:my_money/helpers/formatters.dart';

class FilterTransactionsForm extends StatefulWidget {
  final List<CategoryModel> categorias;
  final TransactionsFilters filtrosAtuais;
  final Function(TransactionsFilters) onApplyFilters;

  const FilterTransactionsForm({
    super.key,
    required this.filtrosAtuais,
    required this.onApplyFilters,
    required this.categorias,
  });

  @override
  State<FilterTransactionsForm> createState() => _FilterTransactionsFormState();
}

class _FilterTransactionsFormState extends State<FilterTransactionsForm> {
  DateTime? _dataInicio;
  DateTime? _dataFim;
  List<int>? _categoriasSelecionadas = [];
  List<String>? _tiposSelecionados = [];

  @override
  void initState() {
    super.initState();
    _dataInicio = widget.filtrosAtuais.dataInicio;
    _dataFim = widget.filtrosAtuais.dataFim;
    _categoriasSelecionadas = List.from(
      widget.filtrosAtuais.categoriasId ?? [],
    );
    _tiposSelecionados = List.from(widget.filtrosAtuais.tipos ?? []);
  }

  // Função para limpar tudo
  void _limparFiltros() {
    setState(() {
      _dataInicio = null;
      _dataFim = null;
      _categoriasSelecionadas?.clear();
      _tiposSelecionados?.clear();
    });
  }

  // Verifica se há algum filtro ativado
  bool get _hasActiveFilters {
    return _dataInicio != null ||
        _dataFim != null ||
        (_categoriasSelecionadas != null &&
            _categoriasSelecionadas!.isNotEmpty) ||
        (_tiposSelecionados != null && _tiposSelecionados!.isNotEmpty);
  }

  // Abre o calendário nativo para escolher a data
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: CoresGlobal().primaryColor,
              onPrimary: Colors.white,
              surface: CoresGlobal().backgroundColor,
              onSurface: CoresGlobal().textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _dataInicio = picked;
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  // Método auxiliar para criar os campos de data (com visual de underline)
  Widget _buildDateField(
    String hint,
    DateTime? selectedDate,
    bool isStartDate,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: CoresGlobal().borderColor)),
        ),
        child: Text(
          selectedDate != null ? formattedDate(selectedDate.toString()) : hint,
          style: TextStyle(
            color: selectedDate != null
                ? CoresGlobal().textColor
                : CoresGlobal().hintColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Método auxiliar para criar os Checkboxes padronizados
  Widget _buildCheckbox(
    String label,
    bool isChecked,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: CoresGlobal().primaryColor,
                checkColor: Colors.white,
                side: BorderSide(color: CoresGlobal().hintColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: CoresGlobal().textColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: BoxDecoration(
            color: CoresGlobal().backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CoresGlobal().borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // CABEÇALHO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrar transações',
                    style: TextStyle(
                      color: CoresGlobal().textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: CoresGlobal().hintColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SEÇÃO DE DATAS
                      Text(
                        'Data',
                        style: TextStyle(
                          color: CoresGlobal().hintColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField('De', _dataInicio, true),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildDateField('Até', _dataFim, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // SEÇÃO DE CATEGORIAS
                      Text(
                        'Categoria',
                        style: TextStyle(
                          color: CoresGlobal().hintColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      widget.categorias.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Nenhuma categoria encontrada.',
                                style: TextStyle(
                                  color: CoresGlobal().hintColor,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Column(
                              children: widget.categorias.map((cat) {
                                return _buildCheckbox(
                                  cat.name, // Mostra o nome, mas salva o ID
                                  _categoriasSelecionadas?.contains(cat.id) ??
                                      false,
                                  (bool? checked) {
                                    setState(() {
                                      if (checked == true) {
                                        _categoriasSelecionadas?.add(
                                          cat.id,
                                        ); // Salva o ID
                                      } else {
                                        _categoriasSelecionadas?.remove(cat.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 24),
                      // SEÇÃO DE TIPO
                      Text(
                        'Tipo',
                        style: TextStyle(
                          color: CoresGlobal().hintColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCheckbox(
                        'Entrada',
                        _tiposSelecionados?.contains('entrada') ?? false,
                        (checked) {
                          setState(() {
                            checked == true
                                ? _tiposSelecionados?.add('entrada')
                                : _tiposSelecionados?.remove('entrada');
                          });
                        },
                      ),
                      _buildCheckbox(
                        'Saída',
                        _tiposSelecionados?.contains('saida') ?? false,
                        (checked) {
                          setState(() {
                            checked == true
                                ? _tiposSelecionados?.add('saida')
                                : _tiposSelecionados?.remove('saida');
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // BOTÕES DE AÇÃO
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _hasActiveFilters
                            ? () {
                                // Limpa os filtros locais, fecha o modal e aplica filtros vazios
                                _limparFiltros();
                                widget.onApplyFilters(TransactionsFilters());
                                Navigator.pop(context);
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _hasActiveFilters
                                ? CoresGlobal().primaryColor
                                : CoresGlobal().hintColor.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Limpar filtro',
                          style: TextStyle(
                            color: _hasActiveFilters
                                ? CoresGlobal().primaryColor
                                : CoresGlobal().hintColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          final novosFiltros = TransactionsFilters(
                            dataInicio: _dataInicio,
                            dataFim: _dataFim,
                            categoriasId: _categoriasSelecionadas,
                            tipos: _tiposSelecionados,
                          );
                          widget.onApplyFilters(novosFiltros);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CoresGlobal().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Filtrar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
