import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class ExportService {
  final String exportUserEndpoint = EnvService().loadBackendApiFromEnvFile() + "/privacy";

  Future<http.Response> requestExportData() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    return http.post(Uri.parse(exportUserEndpoint), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
  }
}