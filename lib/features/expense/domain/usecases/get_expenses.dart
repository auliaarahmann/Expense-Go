import 'package:expensego/features/expense/domain/entities/expense_entity.dart';
import 'package:expensego/features/expense/domain/repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Stream<List<ExpenseEntity>> call() {
    return repository.getAllExpenses();
  }
}
