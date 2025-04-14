import 'package:expensego/core/network/network_info.dart';
import 'package:expensego/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expensego/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:expensego/features/expense/data/models/expense_model.dart';
import 'package:expensego/features/expense/domain/entities/expense_entity.dart';
import 'package:expensego/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;
  final ExpenseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    if (await networkInfo.isConnected) {
      await remoteDataSource.addExpense(model);
    }
    await localDataSource.addExpense(model);
  }

  @override
  Stream<List<ExpenseEntity>> getAllExpenses() async* {
    if (await networkInfo.isConnected) {
      yield* remoteDataSource.getAllExpenses().asyncMap((remoteList) async {
        // Simpan semua data remote ke local untuk sinkronisasi
        for (final expense in remoteList) {
          await localDataSource.addExpense(expense);
        }
        return remoteList;
      });
    } else {
      final localList = await localDataSource.getAllExpenses();
      yield localList;
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    // TODO: Tambahkan logika hapus data ke remote & local
  }
}
