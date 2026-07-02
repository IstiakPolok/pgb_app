import 'package:flutter/foundation.dart';

@immutable
abstract class TasksEvent {}

class LoadTasks extends TasksEvent {}

class ToggleTaskCompletion extends TasksEvent {
  final String todoId;
  final bool isCompleted;

  ToggleTaskCompletion({required this.todoId, required this.isCompleted});
}
