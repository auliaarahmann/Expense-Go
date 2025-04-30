// lib/features/trip/presentation/blocs/trip_state.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<TripEntity> trips;
  TripLoaded(this.trips);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}
