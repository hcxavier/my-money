import 'package:flutter/material.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/features/transactions/transactions_model.dart';
import 'package:my_money/components/build_category_dropdown.dart';

class NewTransactionForm extends StatefulWidget {
  final VoidCallback onClosePressed;
  final Future<void> Function(String, double, int, String) onRegisterPressed;
  final List<CategoryModel> categorias;
  final Function(List<CategoryModel>)? onCategoriesLoaded;

  final bool isEditMode;
  final int? transactionId;
  final String? initialTitle;
  final double? initialPrice;
  final int? initialCategoryId;
  final String? initialType;

  const NewTransactionForm({
    super.key,
    required this.onClosePressed,
    required this.onRegisterPressed,
    required this.categorias,
    this.onCategoriesLoaded,
    this.transactionId,
    this.initialTitle,
    this.initialPrice,
    this.initialCategoryId,
    this.initialType,
    this.isEditMode = false,
  });

  @override
  State<NewTransactionForm> createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  String _selectedType = 'entrada';
  String? _selectedCategoryId;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _selectedType = widget.initialType ?? '';
      _selectedCategoryId = widget.initialCategoryId
          ?.toString(); // Converte para String
      _titleController.text = widget.initialTitle ?? '';
      _priceController.text = widget.initialPrice != null
          ? widget.initialPrice.toString()
          : '';
    }

    _titleController.addListener(_onFieldChanged);
    _priceController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _priceController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildFilledInputField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CoresGlobal().inputBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: CoresGlobal().textColor, fontSize: 16),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: CoresGlobal().hintColor, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required IconData icon,
    required String text,
    required Color color,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: CoresGlobal().inputBackgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? CoresGlobal().textColor : color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 3. ATUALIZADO: O formulário só é válido se também NÃO estiver submetendo
    final bool isFormValid =
        _titleController.text.trim().isNotEmpty &&
        double.tryParse(_priceController.text) != null &&
        _selectedCategoryId != null &&
        !_isSubmitting;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: CoresGlobal().backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nova transação',
                style: TextStyle(
                  color: CoresGlobal().textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: CoresGlobal().hintColor),
                onPressed: widget.onClosePressed,
              ),
            ],
          ),

          const SizedBox(height: 32),

          _buildFilledInputField(
            hint: 'Descrição',
            controller: _titleController,
          ),

          _buildFilledInputField(
            hint: 'Preço',
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),

          CategoryDropdown(
            selectedCategoryId: _selectedCategoryId,
            categorias: widget.categorias,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategoryId = newValue;
              });
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _buildTypeButton(
                icon: Icons.arrow_circle_up_outlined,
                text: 'Entrada',
                color: CoresGlobal().incomeColor,
                isSelected: _selectedType == 'entrada',
                onPressed: () => setState(() => _selectedType = 'entrada'),
              ),
              const SizedBox(width: 16),
              _buildTypeButton(
                icon: Icons.arrow_circle_down_outlined,
                text: 'Saída',
                color: CoresGlobal().outcomeColor,
                isSelected: _selectedType == 'saida',
                onPressed: () => setState(() => _selectedType = 'saida'),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 4. ATUALIZADO: Botão Cadastrar com lógica assíncrona
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isFormValid
                  ? () async {
                      // Trava o botão e mostra o loading
                      setState(() => _isSubmitting = true);

                      try {
                        // Avisa a HomePage para salvar os dados (convertendo a string do ID para Int)
                        await widget.onRegisterPressed(
                          _titleController.text.trim(),
                          double.parse(_priceController.text),
                          int.parse(_selectedCategoryId!), // Conversão aqui!
                          _selectedType,
                        );

                        // NOTA: Não precisamos limpar os controllers aqui porque
                        // a NavBarMain vai fechar o modal assim que o await terminar!
                      } catch (e) {
                        // Se deu erro na API, destrava o botão para o usuário tentar de novo
                        if (mounted) {
                          setState(() => _isSubmitting = false);
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGlobal().primaryColor,
                disabledBackgroundColor: CoresGlobal().primaryColor.withValues(
                  alpha: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // 5. ATUALIZADO: Mostra o CircularProgressIndicator se estiver submetendo
              child: _isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.isEditMode ? 'Atualizar' : 'Cadastrar',
                      style: TextStyle(
                        color: isFormValid
                            ? CoresGlobal().textColor
                            : CoresGlobal().textColor.withValues(alpha: 0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
