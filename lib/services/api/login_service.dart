import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class LoginService {
  final String loginUserEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/login";
  final String logoutUserEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/logout";

  Future<http.Response> login(String email, String password, String deviceOs, String deviceModel)  {
     return http.post(Uri.parse(loginUserEndpoint),
         headers: {
           'Content-Type': 'application/json',
           'Accept': 'application/json'
         },
         body: jsonEncode(<String, String> {
           "email": email,
           "password": password,
           "device_os": deviceOs,
           "device_model": deviceModel
         }));
  }

  Future<int> logout() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(logoutUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
          'session': sharedPreferencesService.getString("device_session")
        });

    return response.statusCode;
  }

  Future<bool> logoutDevice(String bearer, String session) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(logoutUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $bearer',
          'session': session
        });

    return response.statusCode == 200;
  }
}
