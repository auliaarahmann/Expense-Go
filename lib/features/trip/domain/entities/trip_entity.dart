// lib/features/expense/domain/entities/trip_entity.dart

class TripEntity {
  final String id;
  final String name;
  final double budget;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFlexible;
  final DateTime createdAt;

  TripEntity({
    required this.id,
    required this.name,
    required this.budget,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.isFlexible,
    required this.createdAt,
  });
}
