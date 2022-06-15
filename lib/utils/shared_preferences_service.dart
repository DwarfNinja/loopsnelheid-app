import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  late SharedPreferences sharedPreferences;

  getSharedPreferenceInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  setObject(String name, Object object) async {
    sharedPreferences.setString(name, jsonEncode(object));
  }

  getObject(String name) async {
    final String? object = sharedPreferences.getString(name);
    return jsonDecode(object!);
  }

  setString(String name, String value) async {
    sharedPreferences.setString(name, value);
  }

  getString(String name) {
    final String? string = sharedPreferences.getString(name);

    return string;
  }

  removeString(String name) {
    return sharedPreferences.remove(name);
  }
}
