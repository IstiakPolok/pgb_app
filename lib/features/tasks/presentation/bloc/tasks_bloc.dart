import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgb_app/core/network/api_client.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'package:pgb_app/core/services/sync_manager.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  StreamSubscription<bool>? _syncSubscription;

  TasksBloc() : super(TasksInitial()) {
    _syncSubscription = SyncManager().onSyncStatusChanged.listen((isSyncing) {
      if (!isSyncing) {
        add(LoadTasks());
      }
    });

    on<LoadTasks>((event, emit) async {
      emit(TasksLoading());
      debugPrint('TasksBloc: LoadTasks started');

      // show task from shareprf
      final cached = await SharedPrefsHelper.getsaveTasks();
      if (cached.isNotEmpty) {
        debugPrint('TasksBloc: Emitting ${cached.length} cached tasks');
        emit(TasksLoaded(tasks: cached));
      }

      // show from API
      try {
        final response = await ApiClient.get(todosURL);

        debugPrint('TasksBloc Status Code: ${response.statusCode}');
        debugPrint('TasksBloc Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final decoded = jsonDecode(response.body);
          final List<dynamic> dataList = decoded['data'] ?? [];

          final List<Map<String, dynamic>> mappedTasks = dataList.map((item) {
            final dueAtStr = item['due_at'];
            String timeDue = 'No due date';
            if (dueAtStr != null) {
              try {
                final dt = DateTime.parse(dueAtStr).toLocal();
                final hour = dt.hour > 12
                    ? dt.hour - 12
                    : (dt.hour == 0 ? 12 : dt.hour);
                final ampm = dt.hour >= 12 ? 'PM' : 'AM';
                final minute = dt.minute.toString().padLeft(2, '0');
                timeDue = 'Due $hour:$minute $ampm';
              } catch (_) {}
            }

            return {
              'id': item['id'] ?? '',
              'title': item['title'] ?? '',
              'desc': item['description'] ?? '',
              'timeDue': timeDue,
              'timeDone': timeDue.replaceAll('Due', 'Done'),
              'isCmplt': item['is_completed'] ?? false,
            };
          }).toList();

          // Save new data in sharprf
          await SharedPrefsHelper.saveCachedTasks(mappedTasks);
          emit(TasksLoaded(tasks: mappedTasks));
        } else {
          if (cached.isEmpty) {
            final errorData = jsonDecode(response.body);
            String errorMessage = 'Failed to load tasks';
            if (errorData is Map) {
              if (errorData['error'] is Map &&
                  errorData['error']['message'] != null) {
                errorMessage = errorData['error']['message'];
              } else if (errorData['message'] != null) {
                errorMessage = errorData['message'];
              }
            }
            emit(TasksFailure(error: errorMessage));
          }
        }
      } catch (e) {
        debugPrint('TasksBloc Exception (likely offline): $e');
        if (cached.isEmpty) {
          emit(TasksFailure(error: e.toString()));
        }
      }
    });

    on<ToggleTaskCompletion>((event, emit) async {
      debugPrint('TasksBloc: ToggleTaskCompletion started');

      //  update data in shrprf
      final cached = await SharedPrefsHelper.getsaveTasks();
      String taskTitle = 'Task';
      for (var t in cached) {
        if (t['id'] == event.todoId) {
          t['isCmplt'] = event.isCompleted;
          taskTitle = t['title'] ?? 'Task';
          break;
        }
      }
      await SharedPrefsHelper.saveCachedTasks(cached);

      // 2. show updated list
      emit(TasksLoaded(tasks: cached));

      bool syncSuccess = false;

      try {
        final url = '$todosURL/${event.todoId}';
        final timestamp =
            '${DateTime.now().add(const Duration(days: 100)).toUtc().toIso8601String().split('.').first}Z';
        final requestBody = {
          'is_completed': event.isCompleted,
          'updated_at': timestamp,
        };

        final response = await ApiClient.patch(
          url,
          body: jsonEncode(requestBody),
        );

        debugPrint('Response Status Code (PATCH): ${response.statusCode}');
        debugPrint('Response Body (PATCH): ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          syncSuccess = true;
        }
      } catch (e) {
        debugPrint('TasksBloc PATCH exception: $e');
      }

      if (!syncSuccess) {
        debugPrint(
          'TasksBloc: Network call failed or offline. Saving task completion offline.',
        );
        //  add to sync in shareprf
        final pending = await SharedPrefsHelper.getPendingSync();
        pending.removeWhere((element) => element['todoId'] == event.todoId);
        pending.add({
          'todoId': event.todoId,
          'title': taskTitle,
          'is_completed': event.isCompleted,
          'timestamp': DateTime.now().toIso8601String(),
        });
        await SharedPrefsHelper.savePendingSync(pending);
      } else {
        add(LoadTasks());
      }
    });
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }
}
