import 'package:flutter/material.dart';
import 'package:my_money/components/ui/transaction_card.dart';
import 'package:my_money/features/transactions/transactions_model.dart';

class TransactionsList extends StatelessWidget {
  // Recebe a lista via "Props"
  final List<TransactionModel> transactions;
  final bool isLoading;
  final Function({
    int? idTransacao,
    String? tittleInicial,
    double? precoInicial,
    int? categoriaIdInicial,
    String? tipoInicial,
  })?
  onEdit;
  final Function(int)? onDelete;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.isLoading,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF00B37E)),
        ),
      );
    }

    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 64.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 48,
                color: Color(0xFF7C7C8A),
              ),
              SizedBox(height: 16),
              Text(
                'Nenhuma transação cadastrada.',
                style: TextStyle(color: Color(0xFF7C7C8A), fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: transactions.map((transaction) {
        return TransactionCard(
          key: ValueKey(transaction.id),
          id: transaction.id,
          title: transaction.title,
          amount: transaction.amount,
          category: transaction.category.name,
          date: transaction.createdAt,
          isExpense: transaction.type == "saida",
          onDelete: () {
            // Lógica para deletar a transação
            if (onDelete != null) {
              onDelete!(transaction.id);
            }
          },
          onEdit: () {
            // Lógica para editar a transação
            if (onEdit != null) {
              onEdit!(
                idTransacao: transaction.id,
                tittleInicial: transaction.title,
                precoInicial: transaction.amount,
                categoriaIdInicial: transaction.category.id,
                tipoInicial: transaction.type,
              );
            }
          },
        );
      }).toList(),
    );
  }
}

// Cabeçalho da lista de transações
class TransactionsHeader extends StatelessWidget {
  final int itemCount;

  const TransactionsHeader({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transações',
            style: TextStyle(
              color: Color(0xFFE1E1E6),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '$itemCount itens',
            style: const TextStyle(color: Color(0xFF7C7C8A), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Campo de busca para filtrar transações
class SearchField extends StatelessWidget {
  final VoidCallback onFilterPressed;
  final TextEditingController controller;
  final Function(String value) onSearchChanged;

  const SearchField({
    super.key,
    required this.onFilterPressed,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        onSearchChanged(value);
      },
      decoration: InputDecoration(
        hintText: 'Busque uma transação',
        hintStyle: const TextStyle(color: Color(0xFF7C7C8A)),
        filled: true,
        fillColor: const Color(0xFF121214), // Fundo interno mais escuro
        suffixIcon: IconButton(
          // Transformei o Icon em IconButton
          icon: const Icon(Icons.sort, color: Color(0xFF00B37E)),
          onPressed: onFilterPressed, // Chama a função aqui!
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF323238)), // Borda sutil
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color(0xFF00875F),
          ), // Borda verde ao focar
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
