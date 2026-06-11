import 'dart:convert';

enum TransactionType { income, expense }

enum TransactionCategory {
  alimentacao,
  transporte,
  lazer,
  educacao,
  saude,
  outros,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.alimentacao:
        return 'Alimentação';
      case TransactionCategory.transporte:
        return 'Transporte';
      case TransactionCategory.lazer:
        return 'Lazer';
      case TransactionCategory.educacao:
        return 'Educação';
      case TransactionCategory.saude:
        return 'Saúde';
      case TransactionCategory.outros:
        return 'Outros';
    }
  }
}

class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type.index,
      'category': category.index,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      type: TransactionType.values[map['type']],
      category: TransactionCategory.values[map['category']],
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());
  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));
}
