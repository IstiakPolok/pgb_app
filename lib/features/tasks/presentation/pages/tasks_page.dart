import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/features/locations/presentation/pages/locations_page.dart';
import 'package:pgb_app/features/profile/presentation/pages/profile_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Take inventory count',
      'desc': 'Count shelf stock and storage stock',
      'timeDone': 'Done 9:30 AM',
      'timeDue': 'Due 9:30 AM',
      'isCompleted': true,
    },
    {
      'title': 'Visit branch manager',
      'desc': 'Collect signed documents',
      'timeDone': 'Done 10:00 AM',
      'timeDue': 'Due 10:00 AM',
      'isCompleted': false,
    },
    {
      'title': 'Verify delivery shipment',
      'desc': 'Check items against the manifest',
      'timeDone': 'Done 11:30 AM',
      'timeDue': 'Due 11:30 AM',
      'isCompleted': false,
    },
    {
      'title': 'Update store display',
      'desc': 'Arrange promotional materials',
      'timeDone': 'Done 2:00 PM',
      'timeDue': 'Due 2:00 PM',
      'isCompleted': false,
    },
    {
      'title': 'Submit daily report',
      'desc': 'Log visit summary and photos',
      'timeDone': 'Done 5:00 PM',
      'timeDue': 'Due 5:00 PM',
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = colorScheme.onSurface;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final cardBgColor = theme.cardColor;
    final cardBorderColor = colorScheme.outline;

    final completedCount = _tasks.where((t) => t['isCompleted']).length;
    final totalCount = _tasks.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    // Filter tasks
    final filteredTasks = _tasks.where((task) {
      if (_selectedFilter == 'Pending') return !task['isCompleted'];
      if (_selectedFilter == 'Completed') return task['isCompleted'];
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'My tasks',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Monday, Jun 15',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: subTextColor,
                ),
              ),
              SizedBox(height: 24.h),

              // Today's Progress Card
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: cardBorderColor, width: 1.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's progress",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '$completedCount of $totalCount done',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.h,
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Filter Chips Row
              Row(
                children: [
                  _buildFilterChip('All'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Pending'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Completed'),
                ],
              ),
              SizedBox(height: 24.h),

              // Tasks List
              Expanded(
                child: ListView.separated(
                  itemCount: filteredTasks.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final isCompleted = task['isCompleted'];

                    // Task badge style
                    final badgeBg = isCompleted
                        ? (isDark ? const Color(0xFF132E27) : const Color(0xFFECFDF5))
                        : (isDark ? const Color(0xFF332715) : const Color(0xFFFFFBEB));
                    final badgeText = isCompleted
                        ? const Color(0xFF10B981)
                        : const Color(0xFFD97706);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Find original task index and toggle it
                          final originalIndex = _tasks.indexOf(task);
                          if (originalIndex != -1) {
                            _tasks[originalIndex]['isCompleted'] = !isCompleted;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: cardBorderColor, width: 1.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Custom Checkbox
                            Container(
                              width: 24.r,
                              height: 24.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted ? colorScheme.primary : Colors.transparent,
                                border: Border.all(
                                  color: isCompleted ? colorScheme.primary : Colors.grey.shade400,
                                  width: 2.r,
                                ),
                              ),
                              child: isCompleted
                                  ? Icon(
                                      Icons.check,
                                      size: 16.r,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16.w),

                            // Task Text Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task['title'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted ? Colors.grey : textColor,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    task['desc'],
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  // Clock Info & Badge Row
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14.r,
                                        color: Colors.grey.shade500,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        isCompleted ? task['timeDone'] : task['timeDue'],
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Status Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: badgeBg,
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Text(
                                          isCompleted ? 'Completed' : 'Pending',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: badgeText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
          currentIndex: 0, // Highlight "Tasks"
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF121B22) : Colors.white,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp),
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LocationsPage()),
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

  Widget _buildFilterChip(String filterName) {
    final isSelected = _selectedFilter == filterName;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterName;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: 1.r,
          ),
        ),
        child: Text(
          filterName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
