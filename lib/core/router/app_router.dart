import 'package:go_router/go_router.dart';
import 'package:pgb_app/features/auth/presentation/pages/login_page.dart';
import 'package:pgb_app/features/auth/presentation/pages/register_page.dart';
import 'package:pgb_app/features/main/presentation/pages/main_navigation_page.dart';

class AppRouter {
  static GoRouter createRouter(bool hasToken) {
    return GoRouter(
      initialLocation: hasToken ? '/nav' : '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(path: '/nav', builder: (context, state) => const navBar()),
      ],
    );
  }
}
