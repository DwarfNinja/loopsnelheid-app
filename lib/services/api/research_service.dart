import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';


class ResearchService {
  final String statisticsEndpoint = dotenv.env['BACKEND_API_URL']! + "/stats/research";

  Future<int> getStatistics() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(statisticsEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return response.statusCode;
  }
}
