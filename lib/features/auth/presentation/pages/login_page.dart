import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pgb_app/core/theme/app_spacer.dart';
import 'package:pgb_app/core/theme/app_theme.dart';
import 'package:pgb_app/features/auth/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                v40pad,

                Center(
                  child: SvgPicture.asset(
                    isDark
                        ? 'assets/logos/darkLogoWithName.svg'
                        : 'assets/logos/logoWithName.svg',
                    height: 100.h,
                    fit: BoxFit.contain,
                  ),
                ),

                v16pad,

                // Welcome texts
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                v8pad,
                Text(
                  'Sign in to start your shift',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: isDark
                        ? AppTheme.darkcolorgray
                        : AppTheme.lightcolorgray,
                  ),
                ),
                v40pad,

                // Email Field
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppTheme.darkcolorgray
                        : AppTheme.lightcolorgray,
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
                v16pad,

                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppTheme.darkcolorgray
                        : AppTheme.lightcolorgray,
                  ),
                ),
                v8pad,

                ValueListenableBuilder<bool>(
                  valueListenable: _obscurePassword,
                  builder: (context, isObscured, child) {
                    return TextFormField(
                      obscureText: isObscured,
                      style: TextStyle(fontSize: 15.sp),
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
                v16pad,

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
                v32pad,

                // Sign In Button
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Sign In',
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
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
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
