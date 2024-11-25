import 'package:you_app_test/presentation/pages/home_page.dart';
import 'package:you_app_test/presentation/pages/interest_page.dart';
import 'package:you_app_test/presentation/pages/login_page.dart';
import 'package:you_app_test/presentation/pages/register_page.dart';
import 'package:you_app_test/routes/routes_names.dart';

class PageRoutes {
  static final routes = {
    RoutesNames.login: (context) => const LoginPage(),
    RoutesNames.home: (context) => const HomePage(),
    RoutesNames.interests: (context) =>
        const InterestPage(initialInterests: []),
    RoutesNames.register: (context) => const RegisterPage(),
  };
}
