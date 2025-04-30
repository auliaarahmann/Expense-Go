// lib/features/expense/domain/usecases/add_expense.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/domain/repositories/trip_repository.dart';

class AddTrip {
  final TripRepository repository;

  AddTrip(this.repository);

  Future<void> call(TripEntity trip) {
    return repository.addTrip(trip);
  }
}
