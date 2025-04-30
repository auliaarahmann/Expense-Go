// lib/features/expense/data/repositories/expense_repository_impl.dart

import 'package:expensego/core/network/network_info.dart';
import 'package:expensego/features/trip/data/datasources/trip_local_data_source.dart';
import 'package:expensego/features/trip/data/datasources/trip_remote_data_source.dart';
import 'package:expensego/features/trip/data/models/trip_model.dart';
import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;
  final TripLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TripRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> addTrip(TripEntity trip) async {
    final model = TripModel.fromEntity(trip);
    if (await networkInfo.isConnected) {
      await remoteDataSource.addTrip(model);
    }
    await localDataSource.addTrip(model);
  }

  @override
  Future<void> updateTrip(TripEntity trip) async {
    final model = TripModel.fromEntity(trip);
    if (await networkInfo.isConnected) {
      await remoteDataSource.updateTrip(model);
    }
    await localDataSource.updateTrip(model);
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteTrip(tripId);
    }
    await localDataSource.deleteTrip(tripId);
  }

@override
  Stream<List<TripEntity>> getAllTrips() async* {
    if (await networkInfo.isConnected) {
      yield* remoteDataSource.getAllTrips().asyncMap((remoteList) async {
        // Simpan semua data remote ke local untuk sinkronisasi
        for (final trip in remoteList) {
          await localDataSource.addTrip(trip);
        }
        return remoteList;
      });
    } else {
      final localList = await localDataSource.getAllTrips();
      yield localList;
    }
  }
  

  @override
  Future<TripEntity?> getTripById(String tripId) async {
    if (await networkInfo.isConnected) {
      final remoteTrip = await remoteDataSource.getTripById(tripId);
      if (remoteTrip != null) {
        await localDataSource.addTrip(remoteTrip);
      }
      return remoteTrip;
    } else {
      return await localDataSource.getTripById(tripId);
    }
  }

  // @override
  // Future<List<TripEntity>> getTripsByUser(String userId) async {
  //   if (await networkInfo.isConnected) {
  //     final remoteList = await remoteDataSource.getTripsByUser(userId);
  //     for (final trip in remoteList) {
  //       await localDataSource.addTrip(trip);
  //     }
  //     return remoteList;
  //   } else {
  //     return await localDataSource.getTripsByUser(userId);
  //   }
  // }

}

