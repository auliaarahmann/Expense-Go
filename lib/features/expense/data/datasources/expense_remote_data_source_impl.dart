import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensego/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:expensego/features/expense/data/models/expense_model.dart';

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ExpenseRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await firestore
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toJson());
  }

  @override
  Stream<List<ExpenseModel>> getAllExpenses() {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      // Kalau user belum login, kirim stream kosong
      return const Stream.empty();
    }

    return firestore
        .collection('expenses')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ExpenseModel.fromJson(doc.data()))
                  .toList(),
        );
  }
}
