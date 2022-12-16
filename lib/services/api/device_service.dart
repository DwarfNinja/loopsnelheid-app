import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/device.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';


class DeviceService {
  final String devicesEndpoint = dotenv.env['BACKEND_API_URL']! + "/auth/devices";

  Future<List<Device>> getDevices() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.get(Uri.parse(devicesEndpoint), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });

    List<Device> devices = [];
    jsonDecode(response.body).forEach((device) => devices.add(Device.fromJson(device)));

    return devices;
  }

  Future<bool> markDeviceAsMeasureDevice(String session) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final response = await http.patch(Uri.parse(devicesEndpoint + "/" + session), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferencesService.getString("token")}',
    });
    
    return response.statusCode == 200;
  }
}
