import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/average_measure.dart';
import 'package:loopsnelheidapp/models/default_measure.dart';

import '../../models/measure.dart';
import '../../utils/shared_preferences_service.dart';

class MeasureService {
  final String averageDailyEndpoint = dotenv.env['BACKEND_API_URL']! + "/stats/today";
  final String averageWeeklyEndpoint =  dotenv.env['BACKEND_API_URL']! + "/stats/week";
  final String averageMonthlyEndpoint = dotenv.env['BACKEND_API_URL']! + "/stats/month";
  final String storeMeasureEndpoint = dotenv.env['BACKEND_API_URL']! + "/measures";
  final String defaultMeasuresEndpoint = dotenv.env['BACKEND_API_URL']! + "/measures/default";

  static double convertMsToKmh(double speed) {
    return speed * 3.6;
  }

  Future<AverageMeasure> getAverageDailyMeasure() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(averageDailyEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  //DEFAULT MEASURES ---> START
  Future<String> getDefaultMeasures() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(defaultMeasuresEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return response.body;
    // return DefaultMeasure.fromJson(jsonDecode(response.body));
  }

  //DEFAULT MEASURES ---> END


  Future<AverageMeasure> getAverageWeeklyMeasure() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(averageWeeklyEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }


  Future<AverageMeasure> getAverageMonthlyMeasure() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(averageMonthlyEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  List<Measure> getGraphMeasures(Map<String, dynamic> measures) {
    List<Measure> graphMeasures = [];
    measures.forEach((date, speed) => graphMeasures.add(Measure(date, speed)));

    return graphMeasures;
  }

  void storeMeasures(List<Measure> measures) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();
    await http.post(
      Uri.parse(storeMeasureEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
      },
      body: jsonEncode(measures),
    );
     measures.clear();
  }
}
