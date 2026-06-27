import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/features/auth/presentation/pages/register_page.dart';
import 'package:pgb_app/features/tasks/presentation/pages/tasks_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // A lightweight way to hold UI state in a StatelessWidget
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                // Logo
                Center(
                  child: SvgPicture.asset(
                    isDark
                        ? 'assets/logos/darkLogoWithName.svg'
                        : 'assets/logos/logoWithName.svg',
                    height: 80.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.h),

                // Welcome texts
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign in to start your shift',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Field
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'john.doe@example.com',
                    prefixIcon: Icon(Icons.mail_outline_rounded, size: 22.r),
                  ),
                ),
                SizedBox(height: 20.h),

                // Password Field
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8.h),

                // ValueListenableBuilder listens to _obscurePassword and rebuilds only this field
                ValueListenableBuilder<bool>(
                  valueListenable: _obscurePassword,
                  builder: (context, isObscured, child) {
                    return TextFormField(
                      obscureText: isObscured,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 15.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 22.r,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 22.r,
                          ),
                          onPressed: () {
                            // Toggle the value, which automatically triggers a rebuild of this widget
                            _obscurePassword.value = !isObscured;
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12.h),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TasksPage()),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Bottom register prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

