// lib/features/trip/data/datasources/trip_local_data_source_impl.dart

import 'package:hive/hive.dart';
import 'package:expensego/features/trip/data/models/trip_model.dart';
import 'trip_local_data_source.dart';

class TripLocalDataSourceImpl implements TripLocalDataSource {
  final Box tripBox;

  TripLocalDataSourceImpl(this.tripBox);

  @override
  Future<void> addTrip(TripModel trip) async {
    await tripBox.put(trip.id, trip);
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    await tripBox.put(trip.id, trip);
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    await tripBox.delete(tripId);
  }

  // @override
  // Future<List<TripModel>> getTripsByUser(String userId) async {
  //   return tripBox.values.where((trip) => trip.userId == userId).toList();
  // }

  @override
  Future<TripModel?> getTripById(String tripId) async {
    return tripBox.get(tripId);
  }

  @override
  Future<List<TripModel>> getAllTrips() async {
    return tripBox.values.cast<TripModel>().toList();
  }

  @override
  Future<void> clearAllTrips() async {
    await tripBox.clear();
  }
}
