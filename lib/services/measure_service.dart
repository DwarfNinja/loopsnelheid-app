import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/average_measure.dart';

import '../models/measure.dart';

class MeasureService {
  final String averageWeeklyEndpoint =  dotenv.env['BACKEND_API_URL']! + "/stats/week";
  final String averageMonthlyEndpoint = dotenv.env['BACKEND_API_URL']! + "stats/month";
  final String storeMeasureEndpoint = dotenv.env['BACKEND_API_URL']! + "/measures";

  Future<AverageMeasure> getAverageWeeklyMeasure() async {
    final response = await http.get(Uri.parse(averageWeeklyEndpoint));
    return AverageMeasure.fromJson(jsonDecode(response.body));
  }

  Future<AverageMeasure> getAverageMonthlyMeasure() async {
    final response = await http.get(Uri.parse(averageMonthlyEndpoint));
    return AverageMeasure.fromJson(jsonDecode(response.body));
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
