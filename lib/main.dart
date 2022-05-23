import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loopsnelheidapp/models/measure.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'current_speed_card.dart';
import 'average_speed_card.dart';

import 'app_theme.dart' as app_theme;
import 'services/measure_service.dart';

void main() async {
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
      home: const Dashboard(title: 'Loopsnelheid App Dashboard'),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> weeklyMeasures = {};
  Map<String, dynamic> monthlyMeasures = {};
  double currentSpeedMs = 0;
  double dailySpeedMs = 0;
  double weeklySpeedMs = 0;
  double monthlySpeedMs = 0;

  List<Measure> measureList = [];

  static const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  void initPos() async {
    Stream<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings);
    positionStream.listen((Position? position) {
      setState(() {
        currentSpeedMs = position?.speed ?? 0.0;

        Measure measure = Measure(DateTime.now().toIso8601String(), currentSpeedMs);
        measureList.add(measure);
        MeasureService measureService = MeasureService();
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
    setState(() {});
  }

  @override
  void initState() {
    initPos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.blue,
      key: _globalKey,
      drawer: Drawer(
        child: ListView(
          children: const [],
        ),
      ),
      body: SlidingUpPanel(
        panel: Column(
          children: const [
            SizedBox(height: 10),
            RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
              ),
            ),
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
