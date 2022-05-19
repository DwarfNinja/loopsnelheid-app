import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/average_measure.dart';
import '../models/measure.dart';

class MeasureService {
  //TODO: IP to be replaced for environment
  final String averageDailyEndpoint = "http://192.168.1.160:8080/stats/today";
  final String averageWeeklyEndpoint = "http://192.168.1.160:8080/stats/week";
  final String averageMonthlyEndpoint = "http://192.168.1.160:8080/stats/month";
  final String storeMeasureEndpoint = "http://192.168.1.160:8080/measures";



  Future<AverageMeasure> getAverageDailyMeasure() async {
    final response = await http.get(Uri.parse(averageDailyEndpoint));
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  Future<AverageMeasure> getAverageWeeklyMeasure() async {
    final response = await http.get(Uri.parse(averageWeeklyEndpoint));
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }


  Future<AverageMeasure> getAverageMonthlyMeasure() async {
    final response = await http.get(Uri.parse(averageMonthlyEndpoint));
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  List<Measure> getGraphMeasures(Map<String, dynamic> measures) {
    List<Measure> graphMeasures = [];
    measures.forEach((date, speed) => graphMeasures.add(Measure(date, speed)));


    return graphMeasures;
  }

  void storeMeasures(List<Measure> measures) async {
    await http.post(
      Uri.parse(storeMeasureEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(measures),
    );
  }
}