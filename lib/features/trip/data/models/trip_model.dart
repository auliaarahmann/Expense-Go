// lib/features/trip/data/models/trip_model.dart

// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import 'package:expensego/features/trip/domain/entities/trip_entity.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 0)
class TripModel extends TripEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final double budget;

  @override
  @HiveField(3)
  final DateTime startDate;

  @override
  @HiveField(4)
  final DateTime endDate;

  @override
  @HiveField(5)
  final bool isFlexible;

  @override
  @HiveField(6)
  final String userId;

  @override
  @HiveField(7)
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.name,
    required this.budget,
    required this.startDate,
    required this.endDate,

    required this.isFlexible,
    required this.userId,
    required this.createdAt,
  }) : super(
         id: id,
         name: name,
         budget: budget,
         startDate: startDate,
         endDate: endDate,
         isFlexible: isFlexible,
         userId: userId,
         createdAt: createdAt,
       );

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    id: json['id'],
    name: json['name'],
    budget: (json['budget'] as num).toDouble(),
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    isFlexible: json['isFlexible'] ?? false,
    userId: json['userId'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'budget': budget,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'isFlexible': isFlexible,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TripModel.fromEntity(TripEntity entity) => TripModel(
    id: entity.id,
    name: entity.name,
    budget: entity.budget,
    startDate: entity.startDate,
    endDate: entity.endDate,
    isFlexible: entity.isFlexible,
    userId: entity.userId,
    createdAt: entity.createdAt,
  );
}
