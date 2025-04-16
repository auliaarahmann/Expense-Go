// lib/features/expense/data/datasources/expense_local_data_source.dart

import 'package:expensego/features/expense/data/models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseModel>> getAllExpenses();
  Future<void> clearAllExpenses();
}
