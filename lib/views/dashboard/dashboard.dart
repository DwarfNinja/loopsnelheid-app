import 'package:flutter/material.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/widgets/dashboard/graph.dart';
import 'package:loopsnelheidapp/widgets/dashboard/legend_text.dart';
import 'package:loopsnelheidapp/widgets/dashboard/toggle_button.dart';
import 'package:loopsnelheidapp/widgets/dashboard/current_speed_card.dart';
import 'package:loopsnelheidapp/widgets/dashboard/average_speed_card.dart';

import 'package:loopsnelheidapp/services/api/measure_service.dart';
import 'package:loopsnelheidapp/services/setting/setting_service.dart';
import 'package:loopsnelheidapp/services/location/location_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> weeklyMeasures = {};
  Map<String, dynamic> monthlyMeasures = {};
  double currentSpeedMs = 0;
  double dailySpeedMs = 0;
  double dailyLimitSpeed = 0;
  double weeklySpeedMs = 0;
  double monthlySpeedMs = 0;

  bool weekGraphView = true;

  void getAllMeasureValues() async {
    await MeasureService.getAverageDailyMeasure().then((value) => {
      dailySpeedMs = value.averageSpeed,
      dailyLimitSpeed = value.defaultMeasureBasedOnProfile.speed,
    });

    await MeasureService.getAverageWeeklyMeasure().then((value) => {
      weeklySpeedMs = value.averageSpeed,
      weeklyMeasures = value.measures
    });

    await MeasureService.getAverageMonthlyMeasure().then((value) => {
      monthlySpeedMs = value.averageSpeed,
      monthlyMeasures = value.measures
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var measureSetting = false;
    var measurePermitted = false;

    getAllMeasureValues();

    SettingService.getMeasureSetting().then((value) async {
      measureSetting = value as bool;
      measurePermitted = await SettingService.isMeasureDevice();
      if(measureSetting && measurePermitted) {
        LocationService.startLocationService();
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
            Graph(data: weekGraphView ? weeklyMeasures : monthlyMeasures, status: weekGraphView, limitSpeed: dailyLimitSpeed),
            const SizedBox(height: 15),
            const LegendText(text: "Gemiddelde loopsnelheid", color: app_theme.blue),
            const SizedBox(height: 3),
            LegendText(text: "Aanbevolen Loopsnelheid ($dailyLimitSpeed km/h)", color: app_theme.red),
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
                    CurrentSpeedCard(
                        speed: MeasureService.convertMsToKmh(dailySpeedMs),
                        limitSpeed: dailyLimitSpeed
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AverageSpeedCard(header: "GEM. WEEK", speed: MeasureService.convertMsToKmh(weeklySpeedMs)),
                        const SizedBox(width: 50),
                        AverageSpeedCard(header: "GEM. MAAND", speed: MeasureService.convertMsToKmh(monthlySpeedMs))
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