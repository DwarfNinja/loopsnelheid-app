
class DefaultMeasure {
  List<DefaultMeasure> defaultMaleMeasures;
  List<DefaultMeasure> defaultFemaleMeasures;


  DefaultMeasure( this.defaultMaleMeasures, this.defaultFemaleMeasures) {
    defaultMaleMeasures = defaultFemaleMeasures;
    defaultFemaleMeasures = defaultFemaleMeasures;
  }

  DefaultMeasure.fromJson(Map<String, dynamic> json)
  : defaultMaleMeasures = json['default_male_measures'],
    defaultFemaleMeasures = json['default_female_measures'];

}