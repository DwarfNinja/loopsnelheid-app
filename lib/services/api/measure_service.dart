import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/average_measure.dart';
import 'package:loopsnelheidapp/models/measure.dart';
import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class MeasureService {
  static final String averageDailyEndpoint = EnvService().loadBackendApiFromEnvFile() + "/stats/today";
  static final String averageWeeklyEndpoint =  EnvService().loadBackendApiFromEnvFile() + "/stats/week";
  static final String averageMonthlyEndpoint = EnvService().loadBackendApiFromEnvFile() + "/stats/month";
  static final String storeMeasureEndpoint = EnvService().loadBackendApiFromEnvFile() + "/measures";

  static double convertMsToKmh(double speed) {
    return speed * 3.6;
  }

  static Future<AverageMeasure> getAverageDailyMeasure() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(averageDailyEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  static Future<AverageMeasure> getAverageWeeklyMeasure() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(averageWeeklyEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  static Future<AverageMeasure> getAverageMonthlyMeasure() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(averageMonthlyEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  static List<Measure> getGraphMeasures(Map<String, dynamic> measures) {
    List<Measure> graphMeasures = [];
    measures.forEach((date, speed) => graphMeasures.add(Measure(date, speed)));

    return graphMeasures;
  }

  static void storeMeasures(List<Measure> measures) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();
    await http.post(
      Uri.parse(storeMeasureEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
        'session': sharedPreferencesService.getString("device_session")
      },
      body: jsonEncode(measures),
    );
     measures.clear();
  }
}
