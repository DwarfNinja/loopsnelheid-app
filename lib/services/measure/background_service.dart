import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:loopsnelheidapp/services/measure/activity_service.dart';
import 'package:loopsnelheidapp/services/measure/location_service.dart';

class BackgroundService {

  static Future<void> initializeService() async {
    final backgroundService = FlutterBackgroundService();
    await backgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  static startBackgroundService() async {
    await initializeService();
    final service = FlutterBackgroundService();
    service.startService();
  }

  static stopBackgroundService() async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
    ActivityService.stopActivityService();
    LocationService.stopLocationService();
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
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

    if (ActivityService.isMeasureTimerExpired()) {
      if(DateTime.now().hour > 5) {
        ActivityService.resetMeasureTimer();
      }
      else {
        ActivityService.stopActivityService();
      }
    }
    else {
      ActivityService.startActivityService();
    }

    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (service is AndroidServiceInstance) {
        if (ActivityService.isServiceRunning) {
          if (LocationService.isServiceRunning) {
            service.setForegroundNotificationInfo(
                title: "Loopsnelheid",
                content: "Metingen aan het uitvoeren..."
            );
          }
          else {
            service.setForegroundNotificationInfo(
                title: "Loopsnelheid",
                content: "Loopactiviteit aan het bijhouden..."
            );
          }
        }
      }
    });
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }
}
