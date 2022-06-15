import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../utils/shared_preferences_service.dart';

class LoginService {
  final String loginUserEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/login";
  final String logoutUserEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/logout";

  Future<http.Response> authenticate(String email, String password)  {

     return http.post(Uri.parse(loginUserEndpoint),
         headers: {
           'Content-Type': 'application/json',
           'Accept': 'application/json'
         },
         body: jsonEncode(<String, String> {
           "email": email,
           "password": password
         }));
  }

  Future<bool> logout() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(logoutUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
          'session': sharedPreferencesService.getString("device_session")
        });

    if (response.statusCode == 200) {
      sharedPreferencesService.removeString("token");
      sharedPreferencesService.removeString("device_session");
      sharedPreferencesService.removeString("device_type");
    }

    return response.statusCode == 200;
  }
}
