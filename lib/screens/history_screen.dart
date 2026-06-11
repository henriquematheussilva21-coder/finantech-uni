import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../models/transaction.dart';
import '../theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TransactionType? _filterType;
  TransactionCategory? _filterCategory;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormatter = DateFormat('dd/MM/yyyy');

    var filtered = provider.transactions.where((t) {
      if (_filterType != null && t.type != _filterType) return false;
      if (_filterCategory != null && t.category != _filterCategory) return false;
      return true;
    }).toList();

    return Column(
      children: [
        // Filtros
        Container(
          color: AppColors.primary.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<TransactionType?>(
                  value: _filterType,
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Todos')),
                    DropdownMenuItem(
                        value: TransactionType.income, child: Text('Entradas')),
                    DropdownMenuItem(
                        value: TransactionType.expense, child: Text('Saídas')),
                  ],
                  onChanged: (v) => setState(() => _filterType = v),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<TransactionCategory?>(
                  value: _filterCategory,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas')),
                    ...TransactionCategory.values.map(
                      (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _filterCategory = v),
                ),
              ),
            ],
          ),
        ),

        // Lista
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma transação encontrada.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final t = filtered[index];
                    final isIncome = t.type == TransactionType.income;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIncome
                              ? AppColors.income.withOpacity(0.15)
                              : AppColors.expense.withOpacity(0.15),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color:
                                isIncome ? AppColors.income : AppColors.expense,
                            size: 20,
                          ),
                        ),
                        title: Text(t.description,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            '${t.category.label} • ${dateFormatter.format(t.date)}',
                            style: const TextStyle(fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${isIncome ? '+' : '-'} ${formatter.format(t.amount)}',
                              style: TextStyle(
                                color: isIncome
                                    ? AppColors.income
                                    : AppColors.expense,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.grey, size: 20),
                              onPressed: () => _confirmDelete(context, provider, t.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _confirmDelete(
      BuildContext context, FinanceProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir transação'),
        content: const Text('Tem certeza que deseja excluir esta transação?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              provider.deleteTransaction(id);
              Navigator.pop(ctx);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
