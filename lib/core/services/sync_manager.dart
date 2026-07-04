import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pgb_app/core/network/api_client.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  final StreamController<bool> _syncStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get onSyncStatusChanged => _syncStatusController.stream;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _wasOffline = true;

  Future<void> init() async {
    final results = await Connectivity().checkConnectivity();
    _wasOffline = results.contains(ConnectivityResult.none);

    await _connectivitySubscription?.cancel();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final isCurrentlyOffline = results.contains(ConnectivityResult.none);

      if (_wasOffline && !isCurrentlyOffline) {
        debugPrint(
          'SyncManager: Device came back online. Triggering automatic sync...',
        );
        performSync();
      }

      _wasOffline = isCurrentlyOffline;
    });
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _syncStatusController.close();
  }

  Future<bool> performSync() async {
    if (_isSyncing) {
      debugPrint('SyncManager: Sync already in progress.');
      return false;
    }

    final actions = await SharedPrefsHelper.getPendingSync();
    if (actions.isEmpty) {
      debugPrint('SyncManager: No pending actions to sync.');
      return true;
    }

    final token = await SharedPrefsHelper.getAccessToken();
    if (token == null) {
      debugPrint(
        'SyncManager: Sync skipped because user is not authenticated.',
      );
      return false;
    }

    _isSyncing = true;
    _syncStatusController.add(true);
    List<Map<String, dynamic>> failedActions = [];
    bool success = false;

    try {
      final changesList = actions.map((action) {
        final parsedDate = DateTime.parse(
          action['timestamp'] ?? DateTime.now().toString(),
        );
        final timestamp =
            '${parsedDate.add(const Duration(days: 100)).toUtc().toIso8601String().split('.').first}Z';
        return {
          'todo_id': action['todoId'],
          'is_completed': action['is_completed'] ?? false,
          'updated_at': timestamp,
        };
      }).toList();

      debugPrint('SyncManager: Posting payload changes to: $syncTodosURL');

      final response = await http.post(
        Uri.parse(syncTodosURL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'changes': changesList}),
      );

      debugPrint('SyncManager Response Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> syncedIds = decoded['synced_ids'] ?? [];
        failedActions = actions
            .where((action) => !syncedIds.contains(action['todoId']))
            .toList();
        success = failedActions.isEmpty;
      } else {
        failedActions = actions;
      }
    } catch (e) {
      debugPrint('SyncManager: Exception during sync: $e');
      failedActions = actions;
    }

    await SharedPrefsHelper.savePendingSync(failedActions);
    _isSyncing = false;
    _syncStatusController.add(false);

    return success;
  }
}
