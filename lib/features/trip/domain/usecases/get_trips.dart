// lib/features/trip/domain/usecases/get_expenses.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/domain/repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;

  GetTrips(this.repository);

  Stream<List<TripEntity>> call() {
    return repository.getAllTrips();
  }
}
