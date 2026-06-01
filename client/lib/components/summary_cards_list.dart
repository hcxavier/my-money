import 'package:flutter/material.dart';
import 'package:my_money/components/ui/summary_card.dart';
import 'package:my_money/features/transactions/transactions_model.dart';
import 'package:my_money/helpers/formatters.dart';

class SummaryCardsList extends StatelessWidget {
  final TransactionsMetrics? metricsData;
  final bool isLoading;

  const SummaryCardsList({
    super.key,
    required this.metricsData,
    required this.isLoading,
  });

  Color _getTotalCardColor(double totalBalance) {
    if (totalBalance > 0) return const Color(0xFF00875F);
    if (totalBalance < 0) return const Color(0xFFF75A68);
    return const Color(0xFF323238);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF00875F)),
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SummaryCard(
            title: 'Entradas',
            amount: formattedAmount(metricsData?.entradas.total ?? 0),
            subtitle: metricsData?.entradas.lastDate.isNotEmpty == true
                ? 'Última entrada em ${formattedDate(metricsData!.entradas.lastDate)}'
                : 'Não há movimentações',
            icon: Icons.arrow_circle_up_outlined,
            iconColor: const Color(0xFF00B37E),
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Saídas',
            amount: formattedAmount(metricsData?.saidas.total ?? 0),
            subtitle: metricsData?.saidas.lastDate.isNotEmpty == true
                ? 'Última saída em ${formattedDate(metricsData!.saidas.lastDate)}'
                : 'Não há movimentações',
            icon: Icons.arrow_circle_down_outlined,
            iconColor: const Color(0xFFF75A68),
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Total',
            amount: formattedAmount(metricsData?.total.balance ?? 0),
            subtitle: metricsData?.total.lastDate.isNotEmpty == true
                ? 'De ${formattedDate(metricsData!.total.firstDate)} até ${formattedDate(metricsData!.total.lastDate)}'
                : 'Não há movimentações',
            icon: Icons.attach_money,
            iconColor: Colors.white,
            isTotalCard: true,
            customBackgroundColor: _getTotalCardColor(
              metricsData!.total.balance,
            ),
          ),
        ],
      ),
    );
  }
}
