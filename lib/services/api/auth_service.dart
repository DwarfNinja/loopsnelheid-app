import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../shared_preferences_service.dart';

class AuthService {
  final String authenticatedEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/profile";

  Future<bool> isUserAuthenticated()  async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(authenticatedEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}'
        });

    return response.statusCode == 200;
  }
}
