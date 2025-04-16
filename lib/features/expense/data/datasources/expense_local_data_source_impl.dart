// lib/features/expense/data/datasources/expense_local_data_source_impl.dart

import 'package:expensego/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expensego/features/expense/data/models/expense_model.dart';
import 'package:hive/hive.dart';

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box box;

  ExpenseLocalDataSourceImpl(this.box);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    return box.values.cast<ExpenseModel>().toList();
  }

  @override
  Future<void> clearAllExpenses() async {
    await box.clear();
  }
}
