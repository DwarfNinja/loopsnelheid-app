import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:loopsnelheidapp/custom_page_route.dart';

import 'package:loopsnelheidapp/views/dashboard/dashboard.dart';
import 'package:loopsnelheidapp/views/register/login.dart';
import 'package:loopsnelheidapp/views/register/register_basics.dart';
import 'package:loopsnelheidapp/views/register/register_details.dart';
import 'package:loopsnelheidapp/views/register/register_documents.dart';
import 'package:loopsnelheidapp/views/register/register_verification.dart';
import 'package:loopsnelheidapp/views/settings/devices.dart';
import 'package:loopsnelheidapp/views/settings/settings.dart';

import 'package:loopsnelheidapp/services/api/auth_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
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
    AuthService authService = AuthService();
    return CustomPageRoute(
      settings: settings,
      child: FutureBuilder<bool>(
        future: authService.isUserAuthenticated(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
            generateRouteBasedOnAuthentication(settings.name, snapshot.data)
      ),
    );
  }

  static generateRouteBasedOnAuthentication(String? routeName, bool? authenticated) {
    if(authenticated == null) return Container();

    if(authenticated) {
      switch (routeName) {
        case "/":
          return const Dashboard();
        case "/settings":
          return  const Settings();
        case "/devices":
          return const Devices();
        default:
          return const Dashboard();
      }
    }

    switch (routeName) {
      case "/login":
        return const Login();
      case "/register_basics":
        return const RegisterBasics();
      case "/register_details":
        return const RegisterDetails();
      case "/register_documents":
        return  const RegisterDocuments();
      case "/register_verification":
        return const RegisterVerification();
      default:
        return const Login();
    }
  }
}
