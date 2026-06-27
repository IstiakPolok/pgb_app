import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/features/profile/presentation/pages/profile_page.dart';
import 'package:pgb_app/features/locations/presentation/pages/new_location_page.dart';
import 'package:pgb_app/features/locations/presentation/pages/edit_location_page.dart';
import 'package:pgb_app/features/tasks/presentation/pages/tasks_page.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Custom color mappings based on theme
    final cardBgColor = theme.cardColor;
    final cardBorderColor = colorScheme.outline;
    final textColor = colorScheme.onSurface;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    final activeIconBg = isDark
        ? const Color(0xFF0F3231)
        : const Color(0xFFE6F4F2);
    final activeIconColor = const Color(0xFF0D9488);
    final activeBadgeBg = isDark
        ? const Color(0xFF132E27)
        : const Color(0xFFECFDF5);
    final activeBadgeText = const Color(0xFF10B981);

    final inactiveIconBg = isDark
        ? const Color(0xFF24303B)
        : const Color(0xFFF1F5F9);
    final inactiveIconColor = isDark
        ? Colors.grey.shade500
        : Colors.grey.shade600;
    final inactiveBadgeBg = isDark
        ? const Color(0xFF24303B)
        : const Color(0xFFF1F5F9);
    final inactiveBadgeText = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    final List<Map<String, dynamic>> locations = [
      {
        'name': 'Downtown Branch',
        'coords': '25.2048, 55.2708',
        'radius': '150 m radius',
        'isActive': true,
      },
      {
        'name': 'Warehouse',
        'coords': '25.2101, 55.2801',
        'radius': '200 m radius',
        'isActive': true,
      },
      {
        'name': 'North Depot',
        'coords': '25.1980, 55.2650',
        'radius': '120 m radius',
        'isActive': false,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title and top + button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Locations',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add, color: Colors.white, size: 20.r),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewLocationPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Search Bar
              TextFormField(
                style: TextStyle(color: textColor, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: 'Search locations',
                  prefixIcon: Icon(Icons.search, size: 22.r),
                ),
              ),
              SizedBox(height: 24.h),

              // Locations List
              Expanded(
                child: ListView.separated(
                  itemCount: locations.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final item = locations[index];
                    final bool isActive = item['isActive'];

                    return GestureDetector(
                      onTap: () {
                        final radiusVal =
                            double.tryParse(item['radius'].split(' ').first) ??
                            150.0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLocationPage(
                              initialName: item['name'],
                              initialCoords: item['coords'],
                              initialRadius: radiusVal,
                              initialIsActive: isActive,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: cardBorderColor,
                            width: 1.r,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Left pin icon container
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: isActive ? activeIconBg : inactiveIconBg,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 24.r,
                                color: isActive
                                    ? activeIconColor
                                    : inactiveIconColor,
                              ),
                            ),
                            SizedBox(width: 16.w),

                            // Text Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.explore_outlined,
                                        size: 14.r,
                                        color: subTextColor,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        item['coords'],
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: subTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  // Badges
                                  Row(
                                    children: [
                                      // Radius Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF24303B)
                                              : const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Text(
                                          item['radius'],
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: subTextColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      // Active/Inactive Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? activeBadgeBg
                                              : inactiveBadgeBg,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Text(
                                          isActive ? 'Active' : 'Inactive',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isActive
                                                ? activeBadgeText
                                                : inactiveBadgeText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Suffix Arrow
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.r,
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewLocationPage()),
          );
        },
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.add, size: 28.r, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white.withAlpha(13) : Colors.grey.shade200,
              width: 1.r,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 1, // Highlight "Locations"
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF121B22) : Colors.white,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: isDark
              ? Colors.grey.shade600
              : Colors.grey.shade400,
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp),
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TasksPage()),
              );
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sync_rounded),
              label: 'Sync',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
