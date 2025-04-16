// lib/features/expense/domain/usecases/add_expense.dart

import 'package:expensego/features/expense/domain/entities/expense_entity.dart';
import 'package:expensego/features/expense/domain/repositories/expense_repository.dart';

class UpdateExpense {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  Future<void> call(ExpenseEntity expense) {
    return repository.updateExpense(expense);
  }
}
