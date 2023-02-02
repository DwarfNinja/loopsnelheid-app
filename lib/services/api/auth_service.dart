import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/device.dart';
import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'device_service.dart';

class AuthService {
  final String authenticatedEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile";
  final String devicesEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/devices";

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

  Future<bool> userHasValidSession() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final session = sharedPreferencesService.getString("device_session");
    if (session != null) {
      return DeviceService().getDevices().then((devices) {
        for (Device device in devices) {
          if (device.session == session) {
            return true;
          }
        }
        return false;
      });
    }
    return false;
  }

  Future<bool> isUserAuthenticatedAndHasValidSession() async {
    return Future.wait([isUserAuthenticated(), userHasValidSession()])
        .then((value) {
          return (value[0] && value[1]);
    });
  }
}
