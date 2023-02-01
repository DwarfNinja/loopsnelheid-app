import 'package:device_preview/device_preview.dart' as device_preview;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/custom_page_route.dart';
import 'package:loopsnelheidapp/services/api/auth_service.dart';
import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/views/account/account.dart';
import 'package:loopsnelheidapp/views/account/edit_basics.dart';
import 'package:loopsnelheidapp/views/account/edit_details.dart';
import 'package:loopsnelheidapp/views/dashboard/dashboard.dart';
import 'package:loopsnelheidapp/views/register/forgot_password.dart';
import 'package:loopsnelheidapp/views/register/login.dart';
import 'package:loopsnelheidapp/views/register/register_basics.dart';
import 'package:loopsnelheidapp/views/register/register_details.dart';
import 'package:loopsnelheidapp/views/register/register_documents.dart';
import 'package:loopsnelheidapp/views/register/register_verification.dart';
import 'package:loopsnelheidapp/views/settings/devices.dart';
import 'package:loopsnelheidapp/views/settings/settings.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  if ((EnvService().loadFromEnvFile("DEVICE_PREVIEW") as String).toBoolean() == true) {
    runApp(device_preview.DevicePreview(
        builder: (context) => const MyApp(),
        enabled: !kReleaseMode));
  }
  else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      navigatorKey.currentState!.pushNamed(getCurrentRouteUsingNavigatorKey() ?? "/");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Loopsnelheid App',
      theme: app_theme.themeData,
      navigatorKey: navigatorKey,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  String? getCurrentRouteUsingNavigatorKey() {
    String? currentPath;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return CustomPageRoute(
      settings: settings,
      child: FutureBuilder<bool>(
        future: AuthService().isUserAuthenticatedAndHasValidSession(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          bool isUserAuthenticatedAndHasSession = snapshot.data as bool;
          return generateRouteBasedOnAuthentication(settings.name, isUserAuthenticatedAndHasSession);
        }
      ),
    );
  }

  Widget generateRouteBasedOnAuthentication(String? routeName, bool authenticated) {
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
        case "/edit_basics":
          return const EditBasics();
        case "/edit_details":
          return const EditDetails();
        default:
          return const Dashboard();
      }
    }

    switch (routeName) {
      case "/login":
        return const Login();
      case "/forgot_password":
        return const ForgotPassword();
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
