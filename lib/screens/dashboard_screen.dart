import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/finance_provider.dart';
import '../models/transaction.dart';
import '../theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saldo
          Card(
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo do mês',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatter.format(provider.balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _SummaryChip(
                        label: 'Entradas',
                        value: formatter.format(provider.totalIncome),
                        color: AppColors.income,
                        icon: Icons.arrow_downward,
                      ),
                      const SizedBox(width: 16),
                      _SummaryChip(
                        label: 'Saídas',
                        value: formatter.format(provider.totalExpense),
                        color: AppColors.expense,
                        icon: Icons.arrow_upward,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Gráfico
          if (provider.expensesByCategory.isNotEmpty) ...[
            const Text(
              'Gastos por categoria',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _CategoryChart(provider: provider),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Últimas transações
          const Text(
            'Últimas transações',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),

          if (provider.transactions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Nenhuma transação ainda.\nToque em + para adicionar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            )
          else
            ...provider.transactions.take(5).map(
                  (t) => _TransactionTile(transaction: t, formatter: formatter),
                ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 11)),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChart extends StatelessWidget {
  final FinanceProvider provider;

  const _CategoryChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final data = provider.expensesByCategory.entries.toList();
    final total = data.fold(0.0, (sum, e) => sum + e.value);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: data.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                final percent = total > 0 ? (e.value / total * 100) : 0;
                return PieChartSectionData(
                  color: AppColors.categoryColors[
                      index % AppColors.categoryColors.length],
                  value: e.value,
                  title: '${percent.toStringAsFixed(0)}%',
                  radius: 70,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: data.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.categoryColors[
                        index % AppColors.categoryColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(e.key.label, style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat formatter;

  const _TransactionTile({
    required this.transaction,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isIncome ? AppColors.income.withOpacity(0.15) : AppColors.expense.withOpacity(0.15),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? AppColors.income : AppColors.expense,
            size: 20,
          ),
        ),
        title: Text(transaction.description,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(transaction.category.label,
            style: const TextStyle(fontSize: 12)),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${formatter.format(transaction.amount)}',
          style: TextStyle(
            color: isIncome ? AppColors.income : AppColors.expense,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
