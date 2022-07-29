import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

class SettingService {
  static Future<Object?> getMeasureSetting() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    return sharedPreferencesService.getBool("measure");
  }

  static Future<bool> isMeasureDevice() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    final measureDeviceType = sharedPreferencesService.getString("device_type");
    if(measureDeviceType == null) return false;

    return measureDeviceType == 'MEASURING_DEVICE';
  }
}