import 'package:intl/intl.dart';

String formattedAmount(double amount) {
  // formata o número para o padrão de moeda brasileiro
  final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  // usa o abs() para ignorar o sinal negativo e adicionar depois caso seja despesa
  return formatCurrency.format(amount);
}

String formattedDate(String date) {
  try {
    // tenta coverter o texto da API em DateTime
    final parsedDate = DateTime.parse(date);
    // formata a data para o padrão de exibição DD/MM/YYYY
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  } catch (e) {
    // Se der erro de conversão retorna ela mesma
    return date;
  }
}

String formattedDateComplete(String? isoDate) {
  if (isoDate == null) return '';
  final date = DateTime.parse(isoDate).toLocal();
  const months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  return "${date.day} de ${months[date.month - 1]}";
}

String formattedTotalDate(String? first, String? last) {
  if (first == null || last == null) return 'Não há movimentações';
  final d1 = DateTime.parse(first);
  final d2 = DateTime.parse(last);

  String pad(int n) => n.toString().padLeft(2, '0');
  return 'De ${pad(d1.day)}/${pad(d1.month)}/${d1.year} até ${pad(d2.day)}/${pad(d2.month)}/${d2.year}';
}
