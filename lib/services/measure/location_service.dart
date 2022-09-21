import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import 'package:loopsnelheidapp/models/measure.dart';

import 'package:loopsnelheidapp/services/api/measure_service.dart';

class LocationService {
  static List<Measure> measureList = [];

  static bool isServiceRunning = false;

  static const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
  );

  static Future<void> initializeService() async {
    final backgroundService = FlutterBackgroundService();
    await backgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onLocationStart,
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onLocationStart,
        onBackground: onIosBackground,
      ),
    );
  }

  static startLocationService() async {
    await initializeService();
    final service = FlutterBackgroundService();
    service.startService();
    isServiceRunning = true;
  }

  static stopLocationService() async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
    isServiceRunning = false;
  }

  @pragma('vm:entry-point')
  static void onLocationStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    await dotenv.load();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
            title: "Loopsnelheid",
            content: "Metingen aan het uitvoeren..."
        );
      }
    });

    Stream<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings);
    positionStream.listen((Position? position) {
      var speed = position?.speed ?? 0.0;
      var convertedSpeed = MeasureService.convertMsToKmh(speed);
      Measure measure = Measure(DateTime.now().toIso8601String(), convertedSpeed);
      measureList.add(measure);
    });

    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (measureList.isNotEmpty) {
        MeasureService.storeMeasures(measureList);
      }
    });
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }
}
