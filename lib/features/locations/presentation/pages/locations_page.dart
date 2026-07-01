import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/features/locations/presentation/pages/new_location_page.dart';
import 'package:pgb_app/features/locations/presentation/pages/edit_location_page.dart';

import '../../../../core/theme/app_theme.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final iconBgColor = isdark
        ? AppTheme.darkcolorprimarylight
        : AppTheme.lightcolorprimarylight;
    final inactiveBadgeBg = isdark
        ? AppTheme.darkcolorinactivebadge
        : AppTheme.lightcolorinactivebadge;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Locations',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
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
                      icon: Icon(
                        Icons.add,
                        color: colorScheme.surface,
                        size: 20.r,
                      ),
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

              TextFormField(
                style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.primaryContainer,
                  hintText: 'Search locations',
                  prefixIcon: Icon(Icons.search, size: 22.r),
                ),
              ),
              SizedBox(height: 24.h),

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
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1.r,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: isActive ? iconBgColor : inactiveBadgeBg,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 30.r,
                                color: isActive
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 16.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.explore_outlined,
                                        size: 14.r,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        item['coords'],
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),

                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Text(
                                          item['radius'],
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurfaceVariant,
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
                                              ? colorScheme.primary
                                              : colorScheme.surface,
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
                                                ? colorScheme.surface
                                                : colorScheme.onSurfaceVariant,
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
                              color: colorScheme.onSurfaceVariant,
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
        child: Icon(Icons.add, size: 28.r, color: colorScheme.surface),
      ),
    );
  }
}
