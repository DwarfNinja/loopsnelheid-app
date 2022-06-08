import 'dart:core';

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
        averageSpeed = json['average_speed'],
        amountOfMeasures = json['amount_of_measures'],
        measures = json['average_measure'];
}