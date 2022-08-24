import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_preview/device_preview.dart' as device_preview;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:loopsnelheidapp/custom_page_route.dart';

import 'package:loopsnelheidapp/services/env_service.dart';

import 'package:loopsnelheidapp/views/dashboard/dashboard.dart';
import 'package:loopsnelheidapp/views/register/login.dart';
import 'package:loopsnelheidapp/views/register/register_basics.dart';
import 'package:loopsnelheidapp/views/register/register_details.dart';
import 'package:loopsnelheidapp/views/register/register_documents.dart';
import 'package:loopsnelheidapp/views/register/register_verification.dart';
import 'package:loopsnelheidapp/views/settings/devices.dart';
import 'package:loopsnelheidapp/views/settings/settings.dart';
import 'package:loopsnelheidapp/views/account/account.dart';

import 'package:loopsnelheidapp/services/api/auth_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  if ((EnvService().loadFromEnvFile("WEB_DEBUG") as String).toBoolean() == true) {
    runApp(device_preview.DevicePreview(
        builder: (context) => const MyApp(),
        enabled: !kReleaseMode));
  }
  else {
    runApp(const MyApp());
  }
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
        case "/account":
          return const Account();
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

extension on String {
  bool toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0"
        ? false
        : throw UnsupportedError("Cannot convert \"${this}\" to type bool"));
  }
}
