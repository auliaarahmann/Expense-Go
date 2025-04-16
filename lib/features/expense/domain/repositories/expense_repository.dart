// lib/features/expense/domain/repositories/expense_repository.dart

import 'package:expensego/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseEntity>> getAllExpenses();
  Future<void> addExpense(ExpenseEntity expense);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
}
