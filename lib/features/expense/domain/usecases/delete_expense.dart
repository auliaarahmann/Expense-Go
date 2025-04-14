import 'package:expensego/features/expense/domain/repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  Future<void> call(String id) {
    return repository.deleteExpense(id);
  }
}
