import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/services/env_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class ProfileService {
  static final String profileEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile";
  static final String deleteEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile/delete";

  static final String forgotPasswordEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/reset/password";
  static final String passwordEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile/password";

  static final String emailEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile/email";
  static final String personalEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/profile/personal";

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

  static Future<int> forgotPassword(String email) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(forgotPasswordEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    },
        body: jsonEncode({"email": email})
    );
    return response.statusCode;
  }

  static Future<int> changePassword(String currentPassword, String newPassword) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(passwordEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    },
    body: jsonEncode({"old_password": currentPassword, "new_password": newPassword})
    );
    return response.statusCode;
  }

  static Future<int> changeEmail(String email) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(emailEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    },
        body: jsonEncode({"email": email})
    );
    return response.statusCode;
  }

  static Future<int> changeDetails(String sex, String dateOfBirth, int height, int weight, bool isResearchCandidate) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.post(Uri.parse(personalEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    },
        body: jsonEncode({"sex": sex, "dateOfBirth": dateOfBirth, "length": height, "weight": weight, "is_research_candidate": isResearchCandidate})
    );
    return response.statusCode;
  }
}
