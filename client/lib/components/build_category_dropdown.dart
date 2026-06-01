import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/features/transactions/transactions_model.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategoryId;
  final List<CategoryModel> categorias;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.categorias,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CoresGlobal().inputBackgroundColor, // Fundo do campo (fechado)
        borderRadius: BorderRadius.circular(6),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: const Color(0xFF323238),
          hoverColor: Colors.transparent,
        ),
        child: DropdownButtonFormField<String>(
          value: selectedCategoryId,
          dropdownColor: const Color(0xFF29292E),
          borderRadius: BorderRadius.circular(8),
          elevation: 8,
          icon: Icon(Icons.keyboard_arrow_down, color: CoresGlobal().hintColor),
          decoration: InputDecoration(
            hintText: 'Categoria',
            hintStyle: TextStyle(color: CoresGlobal().hintColor, fontSize: 16),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
          ),
          items: categorias.isEmpty
              ? null
              : categorias.map((categoria) {
                  final isSelected = selectedCategoryId == categoria.id;

                  return DropdownMenuItem<String>(
                    value: categoria.id.toString(),
                    child: Text(
                      categoria.name,
                      style: TextStyle(
                        color: CoresGlobal().textColor,
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
