// lib/features/trip/domain/usecases/delete_trip.dart

import 'package:expensego/features/trip/domain/repositories/trip_repository.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip(this.repository);

  Future<void> call(String id) {
    return repository.deleteTrip(id);
  }
}
