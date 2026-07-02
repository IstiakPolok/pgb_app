import 'package:flutter/foundation.dart';

@immutable
abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Map<String, dynamic>> tasks;

  TasksLoaded({required this.tasks});
}

class TasksFailure extends TasksState {
  final String error;

  TasksFailure({required this.error});
}
