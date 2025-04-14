import 'package:expensego/features/expense/domain/entities/expense_entity.dart';
import 'package:expensego/features/expense/domain/usecases/add_expense.dart';
import 'package:expensego/features/expense/domain/usecases/get_expenses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpense addExpense;
  final GetExpenses getExpenses;

  ExpenseBloc({required this.addExpense, required this.getExpenses})
    : super(ExpenseInitial()) {
    on<LoadExpenses>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await emit.forEach<List<ExpenseEntity>>(
          getExpenses(), // Stream
          onData: (expenses) => ExpenseLoaded(expenses),
          onError: (e, _) => ExpenseError(e.toString()),
        );
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<AddExpenseRequested>((event, emit) async {
      try {
        await addExpense(
          event.expense,
        ); // ini juga harus class AddExpense punya call(ExpenseEntity)
        add(LoadExpenses()); // trigger load ulang setelah tambah
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });
  }
}
