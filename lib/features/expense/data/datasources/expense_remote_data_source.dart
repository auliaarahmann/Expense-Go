// lib/features/expense/data/datasources/expense_remote_data_source.dart

import 'package:expensego/features/expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Stream<List<ExpenseModel>> getAllExpenses();
}
