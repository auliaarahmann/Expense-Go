// lib/features/trip/data/datasources/trip_local_data_source.dart

import 'package:expensego/features/trip/data/models/trip_model.dart';

abstract class TripLocalDataSource {
  Future<void> addTrip(TripModel trip);
  Future<void> updateTrip(TripModel trip);
  Future<void> deleteTrip(String tripId);
  Future<TripModel?> getTripById(String tripId);
  // Future<List<TripModel>> getTripsByUser(String userId);
  Future<List<TripModel>> getAllTrips();
  Future<void> clearAllTrips();
}
