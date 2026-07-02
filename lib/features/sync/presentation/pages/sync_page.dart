import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:pgb_app/core/theme/app_spacer.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isSyncing = false;
  int _pendingCount = 0;
  String _lastSynced = 'Last synced today';
  List<Map<String, dynamic>> _pendingSyncActions = [];
  bool _isOffline = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _loadPendingActions();
    _checkConnectivity();

    // Subscribe to real-time connectivity shifts
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isOffline = results.contains(ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = results.contains(ConnectivityResult.none);
    });
  }

  Future<void> _loadPendingActions() async {
    final actions = await SharedPrefsHelper.getPendingSyncActions();
    setState(() {
      _pendingSyncActions = actions;
      _pendingCount = actions.length;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _startSync() async {
    setState(() {
      _isSyncing = true;
    });
    _animationController.repeat();

    final actions = List<Map<String, dynamic>>.from(_pendingSyncActions);
    if (actions.isEmpty) {
      _stopSyncWithMsg('No pending tasks to sync.');
      return;
    }

    final token = await SharedPrefsHelper.getAccessToken();
    if (token == null) {
      _stopSyncWithMsg('Not logged in. Please log in first.');
      return;
    }

    List<Map<String, dynamic>> failedActions = [];

    try {
      final changesList = actions.map((action) {
        final parsedDate = DateTime.parse(action['timestamp'] ?? DateTime.now().toString());
        final timestamp = '${parsedDate.add(const Duration(days: 100)).toUtc().toIso8601String().split('.').first}Z';
        return {
          'todo_id': action['todoId'],
          'is_completed': action['is_completed'] ?? false,
          'updated_at': timestamp,
        };
      }).toList();

      debugPrint('SyncPage posting payload changes to: $syncTodosEndpoint');
      debugPrint('SyncPage payload: ${jsonEncode({'changes': changesList})}');

      final response = await http.post(
        Uri.parse(syncTodosEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'changes': changesList,
        }),
      );

      debugPrint('SyncPage Response Code: ${response.statusCode}');
      debugPrint('SyncPage Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> syncedIds = decoded['synced_ids'] ?? [];
        failedActions = actions.where((action) => !syncedIds.contains(action['todoId'])).toList();
      } else {
        failedActions = actions;
      }
    } catch (e) {
      debugPrint('Exception in SyncPage sync call: $e');
      failedActions = actions;
    }

    await SharedPrefsHelper.savePendingSyncActions(failedActions);
    _pendingSyncActions = failedActions;

    if (mounted) {
      _animationController.stop();
      setState(() {
        _isSyncing = false;
        _pendingCount = failedActions.length;
        final now = DateTime.now();
        final minutes = now.minute.toString().padLeft(2, '0');
        final ampm = now.hour >= 12 ? 'PM' : 'AM';
        final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
        _lastSynced = failedActions.isEmpty
            ? 'Last synced today, $hour:$minutes $ampm'
            : 'Sync partially completed. $hour:$minutes $ampm';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failedActions.isEmpty
                ? 'All tasks synced successfully!'
                : 'Some tasks failed to sync. Check network connection.',
          ),
        ),
      );
    }
  }

  void _stopSyncWithMsg(String msg) {
    if (mounted) {
      _animationController.stop();
      setState(() {
        _isSyncing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Theme values for offline banner
    final bannerBg = isDark ? const Color(0xFF2E220F) : const Color(0xFFFEF3C7);
    final bannerText = isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);

    // Badge styling
    final badgeBg = isDark ? const Color(0xFF2D2115) : const Color(0xFFFFFBEB);
    final badgeText = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);

    // Sync icon background circle
    final syncIconCircleBg = isDark ? const Color(0xFF132D2A) : const Color(0xFFE6F4F1);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Title
                      Text(
                        'Sync',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      v20pad,

                      // Offline Warning Banner
                      if (_isOffline) ...[
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: bannerBg,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                color: bannerText,
                                size: 24.r,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "You're offline",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: bannerText,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Changes are saved on this device',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: bannerText.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        v20pad,
                      ],

                      // Sync Progress / Status Card
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1.r,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Sync rotating icon container
                            RotationTransition(
                              turns: _animationController,
                              child: Container(
                                width: 48.r,
                                height: 48.r,
                                decoration: BoxDecoration(
                                  color: syncIconCircleBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.sync_rounded,
                                  color: colorScheme.primary,
                                  size: 24.r,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _pendingCount > 0
                                        ? '$_pendingCount changes pending'
                                        : 'All data is up to date',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    _isSyncing ? 'Syncing data now...' : _lastSynced,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      v24pad,

                      // Pending Items Title and List
                      if (_pendingCount > 0) ...[
                        Text(
                          'WAITING TO UPLOAD',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        v12pad,
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _pendingSyncActions.length,
                          separatorBuilder: (context, index) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final action = _pendingSyncActions[index];
                            final isCmplt = action['is_completed'] ?? false;
                            final formattedTime = action['timestamp'] != null
                                ? 'Marked ${isCmplt ? "done" : "pending"} • ${DateTime.parse(action['timestamp']).toLocal().hour}:${DateTime.parse(action['timestamp']).toLocal().minute.toString().padLeft(2, "0")}'
                                : 'Marked ${isCmplt ? "done" : "pending"}';

                            return Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: colorScheme.outline,
                                  width: 1.r,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Task icon wrapper
                                  Container(
                                    width: 40.r,
                                    height: 40.r,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF131B26) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Icon(
                                      Icons.task_alt_rounded,
                                      color: colorScheme.onSurfaceVariant,
                                      size: 20.r,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          action['title'] ?? 'Task',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Pending Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'Pending',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: badgeText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Sync Button at Bottom
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
              child: ElevatedButton(
                onPressed: _isSyncing ? null : _startSync,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sync_rounded,
                      size: 20.r,
                      color: isDark ? colorScheme.surface : Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _isSyncing ? 'Syncing...' : 'Sync now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? colorScheme.surface : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
