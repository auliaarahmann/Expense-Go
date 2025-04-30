// lib/features/trip/domain/repositories/trip_repository.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';

abstract class TripRepository {
  Stream<List<TripEntity>> getAllTrips();
  // Future<List<TripEntity>> getTripsByUser(String userId);
  Future<TripEntity?> getTripById(String tripId);
  Future<void> addTrip(TripEntity trip);
  Future<void> updateTrip(TripEntity trip);
  Future<void> deleteTrip(String tripId);
}
