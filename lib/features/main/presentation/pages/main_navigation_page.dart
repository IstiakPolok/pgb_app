import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/features/main/presentation/cubit/navigation_cubit.dart';
import 'package:pgb_app/features/tasks/presentation/pages/tasks_page.dart';
import 'package:pgb_app/features/locations/presentation/pages/locations_page.dart';
import 'package:pgb_app/features/sync/presentation/pages/sync_page.dart';
import 'package:pgb_app/features/profile/presentation/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  final int initialIndex;
  const MainNavigationPage({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(initialIndex: widget.initialIndex),
      child: BlocListener<NavigationCubit, int>(
        listener: (context, state) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != state) {
            _pageController.animateToPage(
              state,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: _MainNavigationPageContent(pageController: _pageController),
      ),
    );
  }
}

class _MainNavigationPageContent extends StatelessWidget {
  final PageController pageController;
  const _MainNavigationPageContent({required this.pageController});

  final List<IconData> icons = const [
    Icons.format_list_bulleted_rounded,
    Icons.location_on_outlined,
    Icons.sync_rounded,
    Icons.person_outline_rounded,
  ];

  final List<String> labels = const ["Tasks", "Locations", "Sync", "Profile"];

  final List<Widget> pages = const [
    TasksPage(),
    LocationsPage(),
    SyncPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final navBarBgColor = isDark ? const Color(0xFF121B22) : Colors.white;
    final inactiveColor = isDark
        ? const Color(0xFF98A4B4)
        : const Color(0xFF94A3B8);
    final activeColor = colorScheme.primary;

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: navBarBgColor,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE2E8F0),
                  width: 1.r,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(icons.length, (index) {
                    final isSelected = currentIndex == index;
                    final currentColor = isSelected
                        ? activeColor
                        : inactiveColor;

                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<NavigationCubit>().changeIndex(index);
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icons[index], color: currentColor, size: 24.r),
                            SizedBox(height: 4.h),

                            Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: currentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
