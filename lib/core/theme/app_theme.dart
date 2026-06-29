import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // light mode colors = lightcolor
  static const Color lightcolorbg = Color(0xFFF4F6F8);
  static const Color lightcolorprimary = Color(0xFF0D9488);
  static const Color lightcoloraccent = Color(0xFF131A24);
  static const Color lightcolorlightgray = Color(0xFFF8FAFC);
  static const Color lightcolordarkinputcolor = Color(0xFF1A242D);
  static const Color lightcolorgray = Color(0xFF5C6675);

  // dark mode colors = darkcolor
  static const Color darkcolorbg = Color(0xFF0E1521);
  static const Color darkcolorprimary = Color(0xFF2DD4BF);
  static const Color darkcoloraccent = Color(0xFFEEF2F7);
  static const Color darkcolorlightgray = Color(0xFF98A4B4);
  static const Color darkcolordarkinputcolor = Color(0x0ff18212);
  static const Color darkcolorgray = Color(0xFF98A4B4);

  // loctions scren colors
  static const Color lightcolorprimarylight = Color(0xFFD6F3EF);
  static const Color darkcolorprimarylight = Color(0xFF123833);
  static const Color lightcolorinactivebadge = Color(0xFFF1F5F9);
  static const Color darkcolorinactivebadge = Color(0xFF24303B);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightcolorbg,
      primaryColor: lightcolorprimary,
      cardColor: Colors.white,

      colorScheme: ColorScheme.light(
        primary: lightcolorprimary,
        secondary: lightcoloraccent,
        surface: lightcolorbg,
        onSurface: Colors.black,
        onSurfaceVariant: lightcolorgray,
        primaryContainer: Colors.white,
        onPrimaryContainer: lightcolorprimary,
        error: const Color(0xFFEF4444),
        outline: Colors.grey.shade200,
      ),
      dividerColor: Colors.grey.shade200,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: lightcoloraccent),
        titleTextStyle: TextStyle(
          color: lightcoloraccent,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightcolorprimary,
          foregroundColor: darkcoloraccent,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
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
          borderSide: BorderSide(color: lightcolorprimary, width: 1.5.r),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkcolorbg,
      primaryColor: darkcolorprimary,
      cardColor: darkcolordarkinputcolor,

      colorScheme: ColorScheme.dark(
        primary: darkcolorprimary,
        secondary: darkcoloraccent,
        surface: darkcolorbg,
        onSurface: darkcoloraccent,
        onSurfaceVariant: darkcolorgray,
        primaryContainer: const Color(0xFF18212F),
        onPrimaryContainer: darkcolorprimary,
        error: const Color(0xFFEF4444),
        outline: Colors.transparent,
      ),
      dividerColor: const Color(0x14FFFFFF),

      appBarTheme: AppBarTheme(
        backgroundColor: darkcolorbg,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkcoloraccent),
        titleTextStyle: TextStyle(
          color: darkcoloraccent,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkcolorprimary,
          foregroundColor: darkcolorbg,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkcolordarkinputcolor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        prefixIconColor: darkcolorlightgray,
        suffixIconColor: darkcolorlightgray,
        hintStyle: TextStyle(color: darkcolorlightgray, fontSize: 15.sp),
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
          borderSide: BorderSide(color: darkcolorprimary, width: 1.5.r),
        ),
      ),
    );
  }
}
