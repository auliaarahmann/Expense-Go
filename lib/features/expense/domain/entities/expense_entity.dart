class ExpenseEntity {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime createdAt;
  final String userId;

  ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.createdAt,
    required this.userId,
  });
}
