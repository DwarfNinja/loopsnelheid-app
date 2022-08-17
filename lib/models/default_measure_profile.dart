import 'dart:core';

class DefaultMeasureProfile {
  int age;
  double speed;

  DefaultMeasureProfile(this.age, this.speed) {
    age = age;
    speed = speed;
  }

  DefaultMeasureProfile.fromJson(Map<String, dynamic> json)
      : age = json['age'],
        speed = json['speed'];
}