import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/measure.dart';

class HttpService {
  final String postsURL = "http://192.168.2.18:8080/measures";

  void storeMeasures(List<Measure> measures) async {
    await http.post(
      Uri.parse(postsURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(measures),
    );
  }
}