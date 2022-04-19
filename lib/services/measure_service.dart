import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/average_measure.dart';
import '../models/measure.dart';

class MeasureService {
  //TODO: IP to be replaced for environment
  final String averageWeeklyEndpoint = "http://192.168.1.160:8080/stats/week";
  final String averageMonthlyEndpoint = "http://192.168.1.160:8080/stats/month";
  final String storeMeasureEndpoint = "http://192.168.1.160:8080/measures";

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