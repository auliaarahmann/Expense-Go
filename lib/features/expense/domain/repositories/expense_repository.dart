import 'package:expensego/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseEntity expense);
  Stream<List<ExpenseEntity>> getAllExpenses();
  Future<void> deleteExpense(String id);
}
