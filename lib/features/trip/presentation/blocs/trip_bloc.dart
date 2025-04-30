// lib/features/trip/presentation/blocs/trip_bloc.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/domain/usecases/add_trip.dart';
import 'package:expensego/features/trip/domain/usecases/update_trip.dart';
import 'package:expensego/features/trip/domain/usecases/delete_trip.dart';
import 'package:expensego/features/trip/domain/usecases/get_trips.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final AddTrip addTrip;
  final UpdateTrip updateTrip;
  final DeleteTrip deleteTrip;
  final GetTrips getTrips;

  TripBloc({
    required this.addTrip,
    required this.updateTrip,
    required this.deleteTrip,
    required this.getTrips,
  }) : super(TripInitial()) {
    on<LoadTrips>((event, emit) async {
      emit(TripLoading());
      try {
        await emit.forEach<List<TripEntity>>(
          getTrips(), // Stream
          onData: (trips) => TripLoaded(trips),
          onError: (e, _) => TripError(e.toString()),
        );
      } catch (e) {
        emit(TripError(e.toString()));
      }
    });

    on<AddTripRequested>((event, emit) async {
      try {
        await addTrip(
          event.trip,
        ); // ini juga harus class AddTrip punya call(TripEntity)
        add(LoadTrips()); // trigger load ulang setelah tambah
      } catch (e) {
        emit(TripError(e.toString()));
      }
    });

    on<DeleteTripRequested>((event, emit) async {
      try {
        await deleteTrip(event.trip.id);
        add(LoadTrips()); // trigger load ulang setelah hapus
      } catch (e) {
        emit(TripError(e.toString()));
      }
    });

    on<UpdateTripRequested>((event, emit) async {
      try {
        await updateTrip(event.trip);
        add(LoadTrips()); // trigger load ulang setelah update
      } catch (e) {
        emit(TripError(e.toString()));
      }
    });
  }
}
