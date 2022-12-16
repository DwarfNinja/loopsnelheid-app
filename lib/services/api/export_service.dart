import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class ExportService {
  final String exportUserEndpoint = dotenv.env['BACKEND_API_URL']! + "/privacy";

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