import 'dart:core';

import 'default_measure_profile.dart';

class AverageMeasure {
  String type;
  double averageSpeed;
  int amountOfMeasures;
  Map<String, dynamic> measures;
  DefaultMeasureProfile defaultMeasureBasedOnProfile;

  AverageMeasure(this.type, this.averageSpeed, this.amountOfMeasures, this.defaultMeasureBasedOnProfile, this.measures) {
    type = type;
    averageSpeed = averageSpeed;
    amountOfMeasures = amountOfMeasures;
    defaultMeasureBasedOnProfile = defaultMeasureBasedOnProfile;
    measures = measures;
  }

  AverageMeasure.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        averageSpeed = json['average_speed'],
        amountOfMeasures = json['amount_of_measures'],
        defaultMeasureBasedOnProfile = DefaultMeasureProfile.fromJson(json['default_measure_based_on_profile']),
        measures = json['average_measure'];
}