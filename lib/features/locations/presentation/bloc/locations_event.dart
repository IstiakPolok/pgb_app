import 'package:flutter/foundation.dart';

@immutable
abstract class LocationsEvent {}

class LoadLocations extends LocationsEvent {}

class UpdateLocation extends LocationsEvent {
  final String locationId;
  final String name;
  final double latitude;
  final double longitude;
  final double radiusM;
  final bool isActive;

  UpdateLocation({
    required this.locationId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusM,
    required this.isActive,
  });
}

class AddLocation extends LocationsEvent {
  final String name;
  final double latitude;
  final double longitude;
  final double radiusM;
  final bool isActive;

  AddLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusM,
    required this.isActive,
  });
}

class DeleteLocation extends LocationsEvent {
  final String locationId;

  DeleteLocation({required this.locationId});
}
