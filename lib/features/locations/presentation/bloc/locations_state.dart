import 'package:flutter/foundation.dart';

@immutable
abstract class LocationsState {}

class LocationsInitial extends LocationsState {}

class LocationsLoading extends LocationsState {}

class LocationsLoaded extends LocationsState {
  final List<Map<String, dynamic>> locations;

  LocationsLoaded({required this.locations});
}

class LocationsFailure extends LocationsState {
  final String error;

  LocationsFailure({required this.error});
}

class LocationUpdateLoading extends LocationsState {}

class LocationUpdateSuccess extends LocationsState {}

class LocationUpdateFailure extends LocationsState {
  final String error;

  LocationUpdateFailure({required this.error});
}

class LocationAddLoading extends LocationsState {}

class LocationAddSuccess extends LocationsState {}

class LocationAddFailure extends LocationsState {
  final String error;

  LocationAddFailure({required this.error});
}

class LocationDeleteLoading extends LocationsState {}

class LocationDeleteSuccess extends LocationsState {}

class LocationDeleteFailure extends LocationsState {
  final String error;

  LocationDeleteFailure({required this.error});
}
