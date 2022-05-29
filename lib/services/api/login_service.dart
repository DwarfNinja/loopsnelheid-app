import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../utils/shared_preferences_service.dart';

class LoginService {
  final String loginUserEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/login";

  Future<http.Response> authenticate(String email, String password) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

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
}
