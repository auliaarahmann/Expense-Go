// lib/features/trip/presentation/blocs/trip_event.dart

import 'package:expensego/features/trip/domain/entities/trip_entity.dart';

abstract class TripEvent {}

class LoadTrips extends TripEvent {}

class AddTripRequested extends TripEvent {
  final TripEntity trip;
  AddTripRequested(this.trip);
}

class DeleteTripRequested extends TripEvent {
  final TripEntity trip;
  DeleteTripRequested(this.trip);
}

class UpdateTripRequested extends TripEvent {
  final TripEntity trip;
  UpdateTripRequested(this.trip);
}
