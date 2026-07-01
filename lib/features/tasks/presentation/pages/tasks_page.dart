import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _selectFiltr = 'All';

  final List<Map<String, dynamic>> _tsk = [
    {
      'title': 'Take inventory count',
      'desc': 'Count shelf stock and storage stock',
      'timeDone': 'Done 9:30 AM',
      'timeDue': 'Due 9:30 AM',
      'isCmplt': true,
    },
    {
      'title': 'Visit branch manager',
      'desc': 'Collect signed documents',
      'timeDone': 'Done 10:00 AM',
      'timeDue': 'Due 10:00 AM',
      'isCmplt': false,
    },
    {
      'title': 'Verify delivery shipment',
      'desc': 'Check items against the manifest',
      'timeDone': 'Done 11:30 AM',
      'timeDue': 'Due 11:30 AM',
      'isCmplt': false,
    },
    {
      'title': 'Update store display',
      'desc': 'Arrange promotional materials',
      'timeDone': 'Done 2:00 PM',
      'timeDue': 'Due 2:00 PM',
      'isCmplt': false,
    },
    {
      'title': 'Submit daily report',
      'desc': 'Log visit summary and photos',
      'timeDone': 'Done 5:00 PM',
      'timeDue': 'Due 5:00 PM',
      'isCmplt': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final iskala = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final comcount = _tsk.where((t) => t['isCmplt']).length;
    final tCount = _tsk.length;
    final prog = tCount > 0 ? comcount / tCount : 0.0;

    final filterTask = _tsk.where((task) {
      if (_selectFiltr == 'Pending') return !task['isCmplt'];
      if (_selectFiltr == 'Completed') return task['isCmplt'];
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'My tasks',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Monday, Jun 15',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),

              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colorScheme.outline, width: 1.r),
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
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '$comcount of $tCount done',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: LinearProgressIndicator(
                        value: prog,
                        minHeight: 8.h,
                        backgroundColor: theme.dividerColor,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  _buildFltr('All'),
                  SizedBox(width: 8.w),
                  _buildFltr('Pending'),
                  SizedBox(width: 8.w),
                  _buildFltr('Completed'),
                ],
              ),
              SizedBox(height: 24.h),

              Expanded(
                child: ListView.separated(
                  itemCount: filterTask.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final task = filterTask[index];
                    final isCmplt = task['isCmplt'];

                    final badgeBg = isCmplt
                        ? (iskala
                              ? const Color(0xFF132E27)
                              : const Color(0xFFECFDF5))
                        : (iskala
                              ? const Color(0xFF332715)
                              : const Color(0xFFFFFBEB));
                    final badgeText = isCmplt
                        ? const Color(0xFF10B981)
                        : const Color(0xFFD97706);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          final originalIndex = _tsk.indexOf(task);
                          if (originalIndex != -1) {
                            _tsk[originalIndex]['isCmplt'] = !isCmplt;
                          }
                        });
                      },
                      child: Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24.r,
                              height: 24.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.r),
                                color: isCmplt
                                    ? Color(0XFF34C77B)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isCmplt
                                      ? Colors.transparent
                                      : colorScheme.onSurfaceVariant,
                                  width: 2.r,
                                ),
                              ),
                              child: isCmplt
                                  ? Icon(
                                      Icons.check,
                                      size: 16.r,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task['title'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isCmplt
                                          ? Colors.grey
                                          : colorScheme.onSurface,
                                      decoration: isCmplt
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

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14.r,
                                        color: Colors.grey.shade500,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        isCmplt
                                            ? task['timeDone']
                                            : task['timeDue'],
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      const Spacer(),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: badgeBg,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Text(
                                          isCmplt ? 'Completed' : 'Pending',
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
    );
  }

  Widget _buildFltr(String filterName) {
    final isSelected = _selectFiltr == filterName;
    final iskala = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectFiltr = filterName;
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
                : (iskala ? Colors.grey.shade800 : Colors.grey.shade300),
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
                : (iskala ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
