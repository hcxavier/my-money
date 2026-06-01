import 'package:flutter/material.dart';

Future<bool?> mostrarModalConfirmacaoExclusao(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF202024), // Fundo escuro do card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            6,
          ), // Bordas arredondadas do padrão
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Color(0xFF7C7C8A), size: 24),
            SizedBox(width: 8),
            Text(
              'Apagar transação?',
              style: TextStyle(
                color: Color(0xFFE1E1E6),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Tem certeza de que deseja apagar esta transação? Esta ação não pode ser desfeita.',
          style: TextStyle(color: Color(0xFFC4C4CC), fontSize: 14, height: 1.5),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          // Botão Cancelar
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false), // Retorna false
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF00875F)), // Borda verde
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF00875F)),
            ),
          ),
          // Botão Apagar
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Retorna true
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF75A68), // Fundo vermelho
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Apagar', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
