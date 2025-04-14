import 'package:expensego/features/expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Stream<List<ExpenseModel>> getAllExpenses();
}
