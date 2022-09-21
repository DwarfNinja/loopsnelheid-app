import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/models/average_measure.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/widgets/dashboard/graph.dart';
import 'package:loopsnelheidapp/widgets/dashboard/legend_text.dart';
import 'package:loopsnelheidapp/widgets/dashboard/toggle_button.dart';
import 'package:loopsnelheidapp/widgets/dashboard/current_speed_card.dart';
import 'package:loopsnelheidapp/widgets/dashboard/average_speed_card.dart';

import 'package:loopsnelheidapp/services/api/measure_service.dart';
import 'package:loopsnelheidapp/services/measure/activity_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  late Future<AverageMeasure> dailyAverageMeasure;
  late Future<AverageMeasure> weeklyAverageMeasure;
  late Future<AverageMeasure> monthlyAverageMeasure;
  late Future<List<AverageMeasure>> graphDataAverageMeasures;

  bool weekGraphView = true;

  void getAllMeasureValues() async {
    dailyAverageMeasure = MeasureService.getAverageDailyMeasure();
    weeklyAverageMeasure = MeasureService.getAverageWeeklyMeasure();
    monthlyAverageMeasure = MeasureService.getAverageMonthlyMeasure();
    graphDataAverageMeasures = Future.wait([weeklyAverageMeasure, monthlyAverageMeasure]);
  }

  @override
  void initState() {
    measureService.getDefaultMeasures().then((value) => {
      print(value)
    });

    super.initState();

    getAllMeasureValues();

    ActivityService.isActivityPermissionGranted().then((activityPermission) async {
      if (activityPermission) {
        ActivityService.startActivityService();
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
        minHeight: 125,
        maxHeight: 550,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 20, right: 20),
        panel: FutureBuilder(
          future: graphDataAverageMeasures,
          builder: (BuildContext context, AsyncSnapshot<List<AverageMeasure>> snapshot) {
            if (snapshot.hasError || snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 5,
                    backgroundColor: app_theme.white,
                    color: app_theme.blue),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                  ),
                ),
                Text("Open",
                    style: app_theme.textTheme.bodyText2),
                const SizedBox(height: 7),
                Graph(data: weekGraphView ? snapshot.data![0].measures : snapshot.data![1].measures,
                          status: weekGraphView,
                          recSpeed: snapshot.data![1].defaultMeasureBasedOnProfile.speed),
                const SizedBox(height: 15),
                LegendText(
                    text: "Gemiddelde loopsnelheid (${
                        weekGraphView ? snapshot.data![0].averageSpeed.toStringAsFixed(1)
                            : snapshot.data![1].averageSpeed.toStringAsFixed(1)} km/h)",
                    color: app_theme.blue),
                const SizedBox(height: 3),
                LegendText(
                    text: "Aanbevolen Loopsnelheid (${snapshot.data![1].defaultMeasureBasedOnProfile.speed.toStringAsFixed(1)} km/h)",
                    color: app_theme.red),
                const SizedBox(height: 22),
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
            );
          }),
        body: Container(
          decoration: const BoxDecoration(
            gradient: app_theme.mainLinearGradient,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    icon: const Icon(Icons.menu),
                    color: Colors.white,
                    iconSize: 38,
                    onPressed: () {
                      _globalKey.currentState?.openDrawer();
                    },
                  ),
                  Text("Menu",
                      style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.white)
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      "Dashboard",
                      style: app_theme.textTheme.headline3!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 25),
                    FutureBuilder(
                      future: dailyAverageMeasure,
                      builder: (BuildContext context, AsyncSnapshot<AverageMeasure> snapshot) {
                        if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                          return const CurrentSpeedCard(
                              speed: 0.0,
                              recSpeed: 0.0,
                              loadingIndicator: true
                          );
                        }
                        return CurrentSpeedCard(
                            speed: snapshot.data!.averageSpeed,
                            recSpeed: snapshot.data!.defaultMeasureBasedOnProfile.speed
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: weeklyAverageMeasure,
                          builder: (BuildContext context, AsyncSnapshot<AverageMeasure> snapshot) {
                            if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                              return const AverageSpeedCard(header: "GEM. WEEK", speed: 0.0, loadingIndicator: true);
                            }
                            return AverageSpeedCard(header: "GEM. WEEK", speed: snapshot.data!.averageSpeed);
                          },
                        ),
                        const SizedBox(width: 50),
                        FutureBuilder(
                          future: monthlyAverageMeasure,
                          builder: (BuildContext context, AsyncSnapshot<AverageMeasure> snapshot) {
                            if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                              return const AverageSpeedCard(header: "GEM. MAAND", speed: 0.0, loadingIndicator: true);
                            }
                            return AverageSpeedCard(header: "GEM. MAAND", speed: snapshot.data!.averageSpeed);
                          },
                        ),
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