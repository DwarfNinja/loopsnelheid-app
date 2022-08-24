import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class ProfileService {
  static final String profileEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile";
  static final String deleteEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile/delete";

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

  static Future<int> deleteAccount() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(deleteEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return response.statusCode;
  }

  static Future<int> cancelAccountDeletion() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.delete(Uri.parse(deleteEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    return response.statusCode;
  }
}
