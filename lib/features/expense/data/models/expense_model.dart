import 'package:expensego/features/expense/domain/entities/expense_entity.dart';
import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends ExpenseEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final double amount;

  @override
  @HiveField(3)
  final String category;

  @override
  @HiveField(4)
  final DateTime createdAt;

  @override
  @HiveField(5)
  final String userId;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.createdAt,
    required this.userId,
  }) : super(
         id: id,
         title: title,
         amount: amount,
         category: category,
         createdAt: createdAt,
         userId: userId,
       );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
    'userId': userId,
  };

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),

      userId: json['userId'],
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) => ExpenseModel(
    id: entity.id,
    title: entity.title,
    amount: entity.amount,
    category: entity.category,
    createdAt: entity.createdAt,
    userId: entity.userId,
  );
}
