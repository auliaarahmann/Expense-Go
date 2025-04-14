import 'package:expensego/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpenseRequested extends ExpenseEvent {
  final ExpenseEntity expense;
  AddExpenseRequested(this.expense);
}
