import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class ResearchService {
  final String statisticsEndpoint = EnvService().loadBackendApiFromEnvFile() + "/stats/research";

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
