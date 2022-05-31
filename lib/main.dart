import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loopsnelheidapp/custom_page_route.dart';
import 'package:loopsnelheidapp/views/register/login.dart';
import 'package:loopsnelheidapp/views/register/register_basics.dart';
import 'package:loopsnelheidapp/views/register/register_details.dart';
import 'package:loopsnelheidapp/views/register/register_documents.dart';
import 'package:loopsnelheidapp/views/settings/settings.dart';
import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';
import 'package:loopsnelheidapp/widgets/dashboard/graph.dart';
import 'package:loopsnelheidapp/widgets/dashboard/legend_text.dart';
import 'package:loopsnelheidapp/widgets/dashboard/toggle_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:loopsnelheidapp/widgets/dashboard/current_speed_card.dart';
import 'package:loopsnelheidapp/widgets/dashboard/average_speed_card.dart';

import 'package:loopsnelheidapp/utils/time_scheduler.dart';

import 'package:loopsnelheidapp/services/api/measure_service.dart';
import 'package:loopsnelheidapp/models/measure.dart';

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
    }
    throw UnsupportedError('Unknown route: ${settings.name}');
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  MeasureService measureService = MeasureService();

  Map<String, dynamic> weeklyMeasures = {'2022-05-25': 1.6, '2022-05-26': 2.3, '2022-05-27': 2.6, '2022-05-28': 3.1, '2022-05-29': 3.5, '2022-05-30': 4.0, '2022-05-31': 3.8};
  Map<String, dynamic> monthlyMeasures = {'2022-05-01': 3.5, '2022-05-08': 4, '2022-05-16': 4.8, '2022-05-25': 5.6};
  double currentSpeedMs = 0;
  double dailySpeedMs = 0;
  double weeklySpeedMs = 0;
  double monthlySpeedMs = 0;

  List<Measure> measureList = [];

  var settings = {};

  bool weekGraphView = true;

  static const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  void initPositionStream() async {
    Stream<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings);
    positionStream.listen((Position? position) {
      setState(() {
        currentSpeedMs = position?.speed ?? 0.0;

        Measure measure = Measure(DateTime.now().toIso8601String(), currentSpeedMs);
        measureList.add(measure);

        if (measureList.length > 1) {
          measureService.storeMeasures(measureList);
          measureList.clear();

          measureService.getAverageDailyMeasure().then((value) => {
            dailySpeedMs = value.averageSpeed,
          });

          measureService.getAverageWeeklyMeasure().then((value) => {
            weeklySpeedMs = value.averageSpeed,
            weeklyMeasures = value.measures
          });

          measureService.getAverageMonthlyMeasure().then((value) => {
            monthlySpeedMs = value.averageSpeed,
            monthlyMeasures = value.measures
          });
        }
      });
    });
  }

  Future<Object?> getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  bool setRandomTime() {
    List times = setRandomTimes();

    TimeOfDay now = TimeOfDay.now();
    double rightNow(TimeOfDay now) => now.hour + now.minute / 60.0;

    if (rightNow(now) >= times[0][0] && rightNow(now) <= times[0][1]) {
      return true;
    } else if (rightNow(now) >= times[1][0] && rightNow(now) <= times[1][1]) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    var measureSetting = false;
    getSetting("measure").then((value) {
      measureSetting = value as bool;
      if(measureSetting && setRandomTime()){
        initPositionStream();
        super.initState();
      } else {
        return 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.blue,
      key: _globalKey,
      drawer: const SideBar(),
      body: SlidingUpPanel(
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
              ),
            ),
            Graph(data: weekGraphView ? weeklyMeasures : monthlyMeasures, status: weekGraphView),
            const SizedBox(height: 15),
            const LegendText(text: "Gemiddelde loopsnelheid", color: app_theme.blue),
            const SizedBox(height: 3),
            const LegendText(text: "Aanbevolen Loopsnelheid", color: app_theme.red),
            const SizedBox(height: 15),
            ToggleButton(
                activeText: "Week",
                inactiveText: "Maand",
                onToggle: (bool value) {
                  setState(() {
                    weekGraphView = value;
                  });
                },
                value: weekGraphView)
          ],
        ),
        minHeight: 100,
        maxHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 20, right: 20),
        body: Container(
          decoration: const BoxDecoration(
            gradient: app_theme.mainLinearGradient,
          ),
          child: Stack(
            children: [
              IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.menu),
                color: Colors.white,
                iconSize: 38,
                onPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      "Loopsnelheid",
                      style: app_theme.textTheme.headline3!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    CurrentSpeedCard(speed: MeasureService.convertMsToKmh(dailySpeedMs)),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AverageSpeedCard(header: "GEM WEEK", speed: MeasureService.convertMsToKmh(weeklySpeedMs)),
                        const SizedBox(width: 50),
                        AverageSpeedCard(header: "GEM MAAND", speed: MeasureService.convertMsToKmh(monthlySpeedMs))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
