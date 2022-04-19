class AverageMeasure {
  String type;
  double averageSpeed;
  int amountOfMeasures;

  AverageMeasure(this.type, this.averageSpeed, this.amountOfMeasures) {
    type = type;
    averageSpeed = averageSpeed;
    amountOfMeasures = amountOfMeasures;
  }

  AverageMeasure.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        averageSpeed = json['averageSpeed'],
        amountOfMeasures = json['amountOfMeasures'];

}