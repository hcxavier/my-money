import 'package:flutter/material.dart';
import 'package:my_money/components/confirm_delete_transaction.dart';
import 'package:my_money/helpers/formatters.dart';

class TransactionCard extends StatelessWidget {
  final int id;
  final String title;
  final double amount;
  final String category;
  final String date;
  final bool isExpense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.isExpense = false,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id.toString()),

      // fundo quando desliza a DIREITA (Editar - Azul)
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2E5B99),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),

      // Fundo quando desliza para a ESQUERDA (Apagar - Vermelho)
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF75A68),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),

      // controla se o item some ou não
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Deslizou para a ESQUERDA (Apagar)
          final bool? shouldDelete = await mostrarModalConfirmacaoExclusao(
            context,
          );

          if (shouldDelete == true) {
            onDelete();
            return true; // Permite que o item seja removido
          }

          return false; // Cancela a exclusão
        } else if (direction == DismissDirection.startToEnd) {
          // Deslizou para a DIREITA (Editar)
          onEdit();
          return false; // Não remove o item, apenas abre a edição
        }

        return false; // Para outras direções, não faz nada
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF29292E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFFC4C4CC), fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '${isExpense || amount < 0 ? '- ' : ''}${formattedAmount(amount)}',
              style: TextStyle(
                color: isExpense || amount < 0
                    ? const Color(0xFFF75A68)
                    : const Color(0xFF00B37E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      color: Color(0xFF7C7C8A),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFF7C7C8A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF7C7C8A),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate(date),
                      style: const TextStyle(
                        color: Color(0xFF7C7C8A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
