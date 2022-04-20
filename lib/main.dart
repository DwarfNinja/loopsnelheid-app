import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
// import 'package:loopsnelheidapp/sidebar.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:loopsnelheidapp/current_speed_card.dart';
import 'package:loopsnelheidapp/average_speed_card.dart';

import 'package:loopsnelheidapp/settings.dart' as settings;

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'dart:io';


void main() async {
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
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  double currentSpeedMs = 0;

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
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    List tijden = settings.setRandomTijden();

    TimeOfDay now = TimeOfDay.now();
    double rightNow(TimeOfDay now) => now.hour + now.minute/60.0;

    if (rightNow(now) >= tijden[0][0] && rightNow(now) <= tijden[0][1]) {
      initPositionStream();
      super.initState();
    } else if (rightNow(now) >= tijden[1][0] && rightNow(now) <= tijden[1][1]) {
      initPositionStream();
      super.initState();
    } else {
      0.0;
    }
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
                    CurrentSpeedCard(speedMs: currentSpeedMs),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AverageSpeedCard(header: "GEM WEEK", speed: "0.0"),
                        SizedBox(width: 50),
                        AverageSpeedCard(header: "GEM MAAND", speed: "0.0")
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
