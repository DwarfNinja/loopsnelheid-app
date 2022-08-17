import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfoService {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? model;
  String? os;

  Future<void> initPlatform() async {
    try {
      if (Platform.isAndroid) {
        model = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        os = "ANDROID";
      } else if (Platform.isIOS) {
        model = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        os = "IOS";
      }
    } on PlatformException {
      initPlatform();
    }
  }

  String? _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.model;
  }

  String? _readIosDeviceInfo(IosDeviceInfo data) {
    return data.model;
  }
}
