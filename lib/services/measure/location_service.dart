import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loopsnelheidapp/models/measure.dart';
import 'package:loopsnelheidapp/services/api/measure_service.dart';
import 'package:pausable_timer/pausable_timer.dart';

class LocationService {
  static StreamSubscription<Position>? positionStream;

  static PausableTimer uploadTimer = PausableTimer(const Duration(minutes: 1), () {
    uploadData();
    uploadTimer.reset();
    uploadTimer.start();
  });

  static List<Measure> measureList = [];

  static bool isServiceRunning = false;

  static const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
  );

  static Future<bool> isAlwaysLocationPermissionGranted() async {
    LocationPermission reqResult;
    reqResult = await Geolocator.checkPermission();
    if (reqResult != LocationPermission.always) {
      reqResult = await Geolocator.requestPermission();
      if (reqResult != LocationPermission.always) {
        return false;
      }
    }
    return true;
  }

  static Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  static void runLocationService() {
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .handleError(onPositionError)
        .listen(onReceivePosition);

    restartUploadTimer();
    isServiceRunning = true;
  }

  static void stopLocationService() {
    cancelMeasuring();
    uploadData();
    cancelUploadTimer();
    isServiceRunning = false;
  }

  static void onReceivePosition(Position position) {
    var speed = position.speed;
    if (speed != 0 && speed < 10) { //TODO: ADD MARGIN
      double convertedSpeed = MeasureService.convertMsToKmh(speed);
      Measure measure = Measure(
          DateTime.now().toIso8601String(), convertedSpeed);
      measureList.add(measure);
    }
  }

  static void uploadData() {
    if (measureList.isNotEmpty) {
      MeasureService.storeMeasures(measureList);
    }
  }

  static void cancelMeasuring() {
    positionStream?.cancel();
  }

  static void restartUploadTimer() {
    uploadTimer.reset();
    uploadTimer.start();
  }

  static void cancelUploadTimer() {
    uploadTimer.cancel();
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  static void onPositionError(dynamic error) {
    print('Catch Error >> $error');
  }
}
