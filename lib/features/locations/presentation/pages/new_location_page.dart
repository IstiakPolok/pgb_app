import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewLocationPage extends StatefulWidget {
  const NewLocationPage({super.key});

  @override
  State<NewLocationPage> createState() => _NewLocationPageState();
}

class _NewLocationPageState extends State<NewLocationPage> {
  double _radius = 150.0;
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = colorScheme.onSurface;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    
    // Map container colors
    final mapBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final mapGridColor = isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5);
    final circleOutlineColor = colorScheme.primary.withAlpha(80);
    final circleFillColor = colorScheme.primary.withAlpha(20);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with back button
                Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: colorScheme.outline, width: 1.r),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: textColor,
                          size: 24.r,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'New location',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Map placeholder
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: mapBgColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Stack(
                    children: [
                      // Grid lines to look like a map grid
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GridPainter(gridColor: mapGridColor),
                        ),
                      ),
                      // Geofence Circle
                      Center(
                        child: Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleFillColor,
                            border: Border.all(color: circleOutlineColor, width: 2.r),
                          ),
                        ),
                      ),
                      // Map pin in center
                      Center(
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 32.r,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Use my current location Button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary, width: 1.r, style: BorderStyle.solid),
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.explore_outlined, size: 20.r),
                      SizedBox(width: 8.w),
                      Text(
                        'Use my current location',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Location name field
                Text(
                  'Location name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15.sp,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Downtown Branch',
                  ),
                ),
                SizedBox(height: 20.h),

                // Lat and Long row
                Row(
                  children: [
                    // Latitude
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latitude',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15.sp,
                            ),
                            decoration: const InputDecoration(
                              hintText: '25.2048',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Longitude
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Longitude',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15.sp,
                            ),
                            decoration: const InputDecoration(
                              hintText: '55.2708',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Geofence radius slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Geofence radius',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '${_radius.round()} m',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.h,
                    activeTrackColor: colorScheme.primary,
                    inactiveTrackColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    thumbColor: colorScheme.primary,
                    overlayColor: colorScheme.primary.withAlpha(30),
                  ),
                  child: Slider(
                    value: _radius,
                    min: 50.0,
                    max: 500.0,
                    onChanged: (value) {
                      setState(() {
                        _radius = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                // Active Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Workers can check in here',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                     Switch.adaptive(
                      value: _isActive,
                      activeTrackColor: colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // Save location Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Save location',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color gridColor;

  GridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    // Draw vertical grid lines
    for (double i = 0; i < size.width; i += 40.w) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal grid lines
    for (double i = 0; i < size.height; i += 40.h) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
