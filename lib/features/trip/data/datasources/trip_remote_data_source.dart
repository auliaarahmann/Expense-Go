// lib/features/trip/data/datasources/trip_remote_data_source.dart

import 'package:expensego/features/trip/data/models/trip_model.dart';

abstract class TripRemoteDataSource {
  Future<void> addTrip(TripModel trip);
  Future<void> updateTrip(TripModel trip);
  Future<void> deleteTrip(String id);
  Stream<List<TripModel>> getAllTrips();
  Future<List<TripModel>> getTripsByUser(String userId);
  Future<TripModel?> getTripById(String tripId);
}
