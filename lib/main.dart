import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_app_test/routes/page_routes.dart';
import 'package:you_app_test/routes/routes_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  print('Access Token: $accessToken');

  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
    ),
    initialRoute: accessToken == null ? RoutesNames.login : RoutesNames.home,
    routes: PageRoutes.routes,
  ));
}
