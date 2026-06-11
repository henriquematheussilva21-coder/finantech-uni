import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

class FinanceProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Goal> _goals = [];
  bool _isLoading = true;

  static const _transactionsKey = 'transactions';
  static const _goalsKey = 'goals';
  final _uuid = const Uuid();

  List<Transaction> get transactions => _transactions;
  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;

  List<Transaction> get thisMonthTransactions {
    final now = DateTime.now();
    return _transactions.where((t) {
      return t.date.year == now.year && t.date.month == now.month;
    }).toList();
  }

  double get totalIncome {
    return thisMonthTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return thisMonthTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpense;

  Map<TransactionCategory, double> get expensesByCategory {
    final Map<TransactionCategory, double> map = {};
    for (final t in thisMonthTransactions
        .where((t) => t.type == TransactionType.expense)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  FinanceProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    _transactions = transactionsJson
        .map((s) => Transaction.fromMap(json.decode(s)))
        .toList();
    _transactions.sort((a, b) => b.date.compareTo(a.date));

    final goalsJson = prefs.getStringList(_goalsKey) ?? [];
    _goals = goalsJson.map((s) => Goal.fromMap(json.decode(s))).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final list =
        _transactions.map((t) => json.encode(t.toMap())).toList();
    await prefs.setStringList(_transactionsKey, list);
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _goals.map((g) => json.encode(g.toMap())).toList();
    await prefs.setStringList(_goalsKey, list);
  }

  Future<void> addTransaction({
    required String description,
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    required DateTime date,
  }) async {
    final transaction = Transaction(
      id: _uuid.v4(),
      description: description,
      amount: amount,
      type: type,
      category: category,
      date: date,
    );
    _transactions.insert(0, transaction);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> addGoal({
    required String title,
    required double targetAmount,
    double savedAmount = 0,
  }) async {
    final goal = Goal(
      id: _uuid.v4(),
      title: title,
      targetAmount: targetAmount,
      savedAmount: savedAmount,
    );
    _goals.add(goal);
    await _saveGoals();
    notifyListeners();
  }

  Future<void> updateGoalSaved(String id, double amount) async {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _goals[index].savedAmount = amount;
      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    await _saveGoals();
    notifyListeners();
  }
}
