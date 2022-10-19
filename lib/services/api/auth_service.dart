import 'package:http/http.dart' as http;

import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/services/env_service.dart';

class AuthService {
  final String authenticatedEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile";

  Future<bool> isUserAuthenticated() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    if (sharedPreferencesService.getString("token") != null) {
      final response = await http.get(Uri.parse(authenticatedEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}'
          });
      return response.statusCode == 200;
    }
    return false;
  }
}
