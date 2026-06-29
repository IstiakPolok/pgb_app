import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/core/theme/app_spacer.dart';
import 'package:pgb_app/core/theme/app_theme.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isSyncing = false;
  String _syncStatus = 'All data is up to date';
  String _lastSynced = 'Last synced: Today, 10:45 AM';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startSync() {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing offline tasks and logs...';
    });
    _animationController.repeat();

    // Simulate network sync
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.stop();
        setState(() {
          _isSyncing = false;
          _syncStatus = 'Sync completed successfully!';
          final now = DateTime.now();
          final minutes = now.minute.toString().padLeft(2, '0');
          final ampm = now.hour >= 12 ? 'PM' : 'AM';
          final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
          _lastSynced = 'Last synced: Today, $hour:$minutes $ampm';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = colorScheme.onSurface;
    final subTextColor = isDark ? AppTheme.darkcolorgray : AppTheme.lightcolorgray;
    final cardBgColor = theme.cardColor;
    final cardBorderColor = colorScheme.outline;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Data Sync',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Keep your offline progress synchronized',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: subTextColor,
                ),
              ),
              v40pad,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotationTransition(
                      turns: _animationController,
                      child: Container(
                        padding: EdgeInsets.all(32.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isSyncing
                              ? colorScheme.primary.withValues(alpha: 0.1)
                              : cardBgColor,
                          border: Border.all(
                            color: _isSyncing ? colorScheme.primary : cardBorderColor,
                            width: 2.r,
                          ),
                        ),
                        child: Icon(
                          Icons.sync_rounded,
                          size: 72.r,
                          color: _isSyncing ? colorScheme.primary : subTextColor,
                        ),
                      ),
                    ),
                    v32pad,
                    Text(
                      _syncStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    v8pad,
                    Text(
                      _lastSynced,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: subTextColor,
                      ),
                    ),
                    v40pad,
                    ElevatedButton.icon(
                      onPressed: _isSyncing ? null : _startSync,
                      icon: const Icon(Icons.sync_rounded),
                      label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
