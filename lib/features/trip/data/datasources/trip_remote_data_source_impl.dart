// lib/features/trip/data/datasources/trip_remote_data_source_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensego/features/trip/data/datasources/trip_remote_data_source.dart';
import 'package:expensego/features/trip/data/models/trip_model.dart';

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TripRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<void> addTrip(TripModel trip) async {
    await firestore.collection('trips').doc(trip.id).set(trip.toJson());
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    await firestore.collection('trips').doc(trip.id).update(trip.toJson());
  }

  @override
  Future<void> deleteTrip(String id) async {
    await firestore.collection('trips').doc(id).delete();
  }

  @override
  Stream<List<TripModel>> getAllTrips() {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      // Kalau user belum login, kirim stream kosong
      return const Stream.empty();
    }

    return firestore
        .collection('trips')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TripModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  @override
  Future<TripModel?> getTripById(String tripId) async {
    final doc = await firestore.collection('trips').doc(tripId).get();
    if (doc.exists) {
      return TripModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<TripModel>> getTripsByUser(String userId) async {
    final snapshot =
        await firestore
            .collection('trips')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => TripModel.fromJson(doc.data())).toList();
  }
}
