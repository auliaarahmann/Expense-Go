// lib/features/expense/domain/usecases/get_expenses.dart

// import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/domain/repositories/trip_repository.dart';

class GetTripsByUser {
  final TripRepository repository;

  GetTripsByUser(this.repository);

  // Future<List<TripEntity>> call(String userId) {
  //   return repository.getTripsByUser(userId);
  // }
}
