import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_app_test/presentation/bloc/register/register_bloc.dart';
import 'package:you_app_test/presentation/bloc/login/login_bloc.dart';
import 'package:you_app_test/presentation/bloc/profile/profile_bloc.dart';
import 'package:you_app_test/routes/page_routes.dart';
import 'package:you_app_test/routes/routes_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => ProfileBloc()),
      BlocProvider(create: (context) => LoginBloc()),
      BlocProvider(create: (context) => RegisterBloc()),
    ],
    child: MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: accessToken == null ? RoutesNames.login : RoutesNames.home,
      routes: PageRoutes.routes,
    ),
  ));
}
