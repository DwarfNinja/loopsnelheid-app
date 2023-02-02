import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Graph extends StatefulWidget {
  final Map<String, dynamic>? data;
  final bool status;
  final double recSpeed;

  const Graph({Key? key, required this.data, required this.status, required this.recSpeed})
      : super(key: key);

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final weekDays = const ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
  final enToNlDays = {
    "Monday": "Ma",
    "Tuesday": "Di",
    "Wednesday": "Wo",
    "Thursday": "Do",
    "Friday": "Vr",
    "Saturday": "Za",
    "Sunday": "Zo"
  };

  double getOffset() {
    return widget.status ? 6 : 32;
  }

  DateTime getDateTimeOfFlSpot(double x) {
    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeOfFlSpot = dateTimeNow.add(Duration(days: x.toInt() - getOffset().toInt()));
    return dateTimeOfFlSpot;
  }

  Widget getXGraphTitle(double x, TitleMeta meta) {
    DateTime dateTimeOfFlSpot = getDateTimeOfFlSpot(x);
    final String formatter = DateFormat('EEEE').format(dateTimeOfFlSpot);
    return Text(widget.status ? enToNlDays[formatter] ?? 'NaN' : dateTimeOfFlSpot.day.toString());
  }

  String formatDateFlSpot(double x, double y) {
    DateTime dateTimeOfFlSpot = getDateTimeOfFlSpot(x);
    final String formatter = DateFormat('dd-MM').format(dateTimeOfFlSpot);
    return '$formatter, ${y.toStringAsFixed(2)}';
  }

  List<FlSpot> createFlSpotListFromData() {
    List<FlSpot> flSpotList =  widget.data!.keys.map((e) {
    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeKey = DateTime.parse("$e 00:00:00.000");
    double differenceInDays = dateTimeNow.difference(dateTimeKey).inDays.toDouble();
    return FlSpot(getOffset() - differenceInDays, double.parse(widget.data![e].toString()));
    }).toList();

    return flSpotList;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      space: 8,
      axisSide: meta.axisSide,
      child: Text(meta.formattedValue),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      space: 7,
      axisSide: meta.axisSide,
      child: getXGraphTitle(value, meta),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 20),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: getOffset(),
            minY: 0,
            maxY: 7,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 200,
                  tooltipBgColor: app_theme.white,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        color: app_theme.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      );
                      return LineTooltipItem(formatDateFlSpot(touchedSpot.x, touchedSpot.y),
                          textStyle);
                    }).toList();
                  }),
              handleBuiltInTouches: true,
              getTouchLineStart: (data, index) => 0,
            ),
            gridData: FlGridData(
              show: true,
              verticalInterval: widget.status ? 1 : 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: app_theme.black,
                  strokeWidth: 1,
                );
              },
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: app_theme.black,
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: app_theme.black, width: 1),
            ),

            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: widget.status ? 1 : 4,
                  reservedSize: 30,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: leftTitleWidgets
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            extraLinesData: ExtraLinesData(
                extraLinesOnTop: false,
                horizontalLines: [
                  HorizontalLine(
                      y: widget.recSpeed,
                      color:
                      app_theme.red,
                      strokeWidth: 4,
                      dashArray: [10, 5]
                  )
                ]
            ),
            lineBarsData: [
              LineChartBarData(
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: app_theme.white,
                      strokeWidth: 3,
                      strokeColor: app_theme.blue,
                    );
                  }
                ),
                spots: createFlSpotListFromData(),
                color: app_theme.blue,
                isCurved: false,
                barWidth: 4
              ),
            ],
          ),
        ),
      ),
    );
  }
}