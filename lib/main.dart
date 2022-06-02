import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:loopsnelheidapp/custom_page_route.dart';
import 'package:loopsnelheidapp/views/dashboard/dashboard.dart';
import 'package:loopsnelheidapp/views/register/login.dart';
import 'package:loopsnelheidapp/views/register/register_basics.dart';
import 'package:loopsnelheidapp/views/register/register_details.dart';
import 'package:loopsnelheidapp/views/register/register_documents.dart';
import 'package:loopsnelheidapp/utils/export/export_view.dart';
import 'package:loopsnelheidapp/views/settings/settings.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'views/register/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Loopsnelheid App',
      theme: app_theme.themeData,
      onGenerateRoute: onGenerateRoute
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return CustomPageRoute(child: const Dashboard());
      case "/settings":
        return CustomPageRoute(child: const Settings());
      case "/login":
        return CustomPageRoute(child: const Login());
      case "/register_basics":
        return CustomPageRoute(child: const RegisterBasics());
      case "/register_details":
        return CustomPageRoute(child: const RegisterDetails());
      case "/register_documents":
        return CustomPageRoute(child: const RegisterDocuments());
      case "/export_view":
        return CustomPageRoute(child: const ExportView());

    }
    throw UnsupportedError('Unknown route: ${settings.name}');
  }
}
