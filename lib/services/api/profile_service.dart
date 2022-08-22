import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class AccountService {
  static final String profileEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile";

  static Future<Profile> getAccount() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(profileEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return Profile.fromJson(jsonDecode(response.body));
  }
}
