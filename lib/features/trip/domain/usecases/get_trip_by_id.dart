// lib/features/expense/domain/usecases/get_expenses.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/domain/repositories/trip_repository.dart';

class GetTripById {
  final TripRepository repository;

  GetTripById(this.repository);

  Future<TripEntity?> call(String id) {
    return repository.getTripById(id);
  }
}
