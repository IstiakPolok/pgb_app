import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/core/theme/app_spacer.dart';
import 'package:pgb_app/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final darknaki = theme.brightness == Brightness.dark;
    final textColor = colorScheme.onSurface;
    final subtileTextColor = colorScheme.onSurfaceVariant;
    final dividerColor = theme.dividerColor;
    final avatarBgColor = darknaki
        ? const Color(0xFF123833)
        : const Color(0xFFD6F3EF);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                v32pad,

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44.r,
                          backgroundColor: avatarBgColor,
                          child: Text(
                            'JD',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        v16pad,
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        v4pad,
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: subtileTextColor,
                          ),
                        ),
                        v12pad,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: avatarBgColor,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 14.r,
                                color: colorScheme.primary,
                              ),
                              h8pad,
                              Text(
                                'Field User',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: dividerColor, width: 1.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: darknaki ? 0.2 : 0.05,
                                ),
                                blurRadius: 10.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1/5',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                ),
                              ),
                              v4pad,
                              Text(
                                'Tasks done today',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: subtileTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      h8pad,
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: darknaki ? 0.2 : 0.05,
                                ),
                                blurRadius: 10.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                ),
                              ),
                              v4pad,
                              Text(
                                'Active locations',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: subtileTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: darknaki ? 0.2 : 0.05,
                        ),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.person_outline_rounded,
                          title: 'Edit profile',
                          textColor: textColor,
                          subtileTextColor: subtileTextColor,
                          dividerColor: dividerColor,
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          textColor: textColor,
                          subtileTextColor: subtileTextColor,
                          dividerColor: dividerColor,
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          textColor: textColor,
                          subtileTextColor: subtileTextColor,
                          dividerColor: dividerColor,
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.help_outline_rounded,
                          title: 'Help & support',
                          textColor: textColor,
                          subtileTextColor: subtileTextColor,
                          dividerColor: dividerColor,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
                v40pad,

                // Sign Out Button
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                  icon: Icon(Icons.logout_rounded, size: 20.r),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(
                      color: colorScheme.error.withValues(alpha: 0.5),
                      width: 1.5.w,
                    ),
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
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

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color textColor,
    required Color subtileTextColor,
    required Color dividerColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: subtileTextColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, size: 22.r, color: subtileTextColor),
                ),
                h12pad,
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.r,
                  color: subtileTextColor,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1.r, thickness: 1.r, color: dividerColor),
      ],
    );
  }
}
