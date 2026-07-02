import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String role;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.role,
  });
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure({required this.error});
}
