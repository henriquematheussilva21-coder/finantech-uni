import 'dart:convert';

class Goal {
  final String id;
  final String title;
  final double targetAmount;
  double savedAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0,
  });

  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory Goal.fromJson(String source) => Goal.fromMap(json.decode(source));
}
