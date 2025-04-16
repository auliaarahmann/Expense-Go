// lib/features/expense/presentation/blocs/expense_event.dart

import 'package:expensego/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpenseRequested extends ExpenseEvent {
  final ExpenseEntity expense;
  AddExpenseRequested(this.expense);
}

class DeleteExpenseRequested extends ExpenseEvent {
  final ExpenseEntity expense;
  DeleteExpenseRequested(this.expense);
}

class UpdateExpenseRequested extends ExpenseEvent {
  final ExpenseEntity expense;
  UpdateExpenseRequested(this.expense);
}
