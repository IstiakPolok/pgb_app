import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/features/auth/presentation/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

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
                SizedBox(height: 20.h),
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

                // Title and Subtitle
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign up to start tracking your shift',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 32.h),

                // Name Field
                Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'John Doe',
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 22.r),
                  ),
                ),
                SizedBox(height: 20.h),

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
                            _obscurePassword.value = !isObscured;
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 36.h),

                // Register Button
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Bottom navigation prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Sign In',
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
