import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D9488);
  static const Color accentColor = Color(0xFF121B22);
  static const Color lightGray = Color(0xFFF8FAFC);
  static const Color darkInputColor = Color(0xFF1A242D);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightGray,
      primaryColor: primaryColor,
      cardColor: Colors.white,
      
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: lightGray,
        onSurface: Colors.black,
        primaryContainer: const Color(0xFFE6F4F2), // Light theme badge background
        onPrimaryContainer: primaryColor, // Light theme badge text
        error: const Color(0xFFEF4444), // Danger color
        outline: Colors.grey.shade200, // Card border color
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: accentColor),
        titleTextStyle: TextStyle(
          color: accentColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        prefixIconColor: Colors.grey.shade400,
        suffixIconColor: Colors.grey.shade400,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5.r),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: accentColor,
      primaryColor: primaryColor,
      cardColor: darkInputColor,

      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: Colors.white,
        surface: accentColor,
        onSurface: Colors.white,
        primaryContainer: const Color(0xFF0F3231), // Dark theme badge background
        onPrimaryContainer: primaryColor, // Dark theme badge text
        error: const Color(0xFFEF4444), // Danger color
        outline: Colors.transparent, // Card border color
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: accentColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        prefixIconColor: Colors.grey.shade600,
        suffixIconColor: Colors.grey.shade600,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5.r),
        ),
      ),
    );
  }
}
