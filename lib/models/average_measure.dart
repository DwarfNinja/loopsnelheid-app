
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/models/measure.dart';

class AverageMeasure {
  String type;
  double averageSpeed;
  int amountOfMeasures;
  Map<String, dynamic> measures;


  AverageMeasure(this.type, this.averageSpeed, this.amountOfMeasures, this.measures) {
    type = type;
    averageSpeed = averageSpeed;
    amountOfMeasures = amountOfMeasures;
    measures = measures;
  }

  AverageMeasure.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        averageSpeed = json['averageSpeed'],
        amountOfMeasures = json['amountOfMeasures'],
        measures = json['averageMeasure'];
}