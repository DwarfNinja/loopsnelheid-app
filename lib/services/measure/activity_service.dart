import 'dart:async';

import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:loopsnelheidapp/services/setting/setting_service.dart';
import 'package:pausable_timer/pausable_timer.dart';

import 'location_service.dart';

class ActivityService {

  static FlutterActivityRecognition activityRecognition = FlutterActivityRecognition.instance;
  static StreamSubscription<Activity>? activityStreamSubscription;

  static PausableTimer measureTimer = PausableTimer(const Duration(minutes: 15), () {
    ActivityService.stopActivityService();
    LocationService.stopLocationService();
  });

  static bool isServiceRunning = false;

  static void startActivityService() {
    activityStreamSubscription = activityRecognition.activityStream
        .handleError(onActivityError)
        .listen(onReceiveActivity);

    isServiceRunning = true;
  }

  static void stopActivityService() {
    activityStreamSubscription?.cancel();
    isServiceRunning = false;
  }

  static Future<bool> isActivityPermissionGranted() async {
    PermissionRequestResult reqResult;
    reqResult = await activityRecognition.checkPermission();
    if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
      return false;
    } else if (reqResult == PermissionRequestResult.DENIED) {
      reqResult = await activityRecognition.requestPermission();
      if (reqResult != PermissionRequestResult.GRANTED) {

        return false;
      }
    }
    return true;
  }

  static void onReceiveActivity(Activity activity) {
    print('Activity Detected >> ${activity.toJson()}');

    if (activity.type == ActivityType.WALKING && (activity.confidence == ActivityConfidence.HIGH)) {
      SettingService.isMeasureDevice().then((isMeasureDevice) async {
        if(isMeasureDevice) {
          LocationService.runLocationService();
          measureTimer.start();
        }
      });
    }
    else if (LocationService.isServiceRunning) {
      LocationService.stopLocationService();
      measureTimer.pause();
    }
  }

  static bool isMeasureTimerExpired() {
    return measureTimer.isExpired;
  }

  static void resetMeasureTimer() {
    measureTimer.reset();
  }

  static void onActivityError(dynamic error) {
    print('Catch Error >> $error');
  }
}
