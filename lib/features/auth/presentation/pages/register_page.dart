import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/core/theme/app_spacer.dart';
import 'package:pgb_app/core/theme/app_assets.dart';
import 'package:pgb_app/features/auth/presentation/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                v20pad,
                Center(
                  child: SvgPicture.asset(
                    isDark
                        ? AppAssets.darkLogoWithoutName
                        : AppAssets.logoWithoutName,
                    height: 60.h,
                    fit: BoxFit.contain,
                  ),
                ),
                v16pad,

                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                v8pad,
                Text(
                  'Sign up to start tracking your shift',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                v32pad,

                Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                v8pad,
                TextFormField(
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 22.r),
                  ),
                ),
                v20pad,
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                v8pad,
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded, size: 22.r),
                  ),
                ),
                v20pad,
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                v8pad,
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
                        hintText: 'Enter Your Password',
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
                v36pad,

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
                v24pad,
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
