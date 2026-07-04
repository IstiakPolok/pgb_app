import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pgb_app/core/theme/app_theme.dart';
import 'package:pgb_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'package:pgb_app/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await SharedPrefsHelper.getAccessToken();
  runApp(PgbApp(hasToken: token != null));
}

class PgbApp extends StatelessWidget {
  final bool hasToken;
  PgbApp({super.key, this.hasToken = false});

  late final GoRouter _router = AppRouter.createRouter(hasToken);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
          child: MaterialApp.router(
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            title: 'FieldTrack',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
          ),
        );
      },
    );
  }
}
