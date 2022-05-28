import 'package:flutter/material.dart';

import 'dart:math';

List setRandomTimes(){
  List<List<double>> randomTimes = [];

  Random random = Random();

  int randomMorningHour = 8 + random.nextInt(12 - 8);
  int randomAfternoonHour = 13 + random.nextInt(17 - 13);

  randomTimes.add(setTimeSpan(randomMorningHour));
  randomTimes.add(setTimeSpan(randomAfternoonHour));

  return randomTimes;
}

List<double> setTimeSpan(randomHour){
  List<double> randomTimes = [];

  Random random = Random();

  int randomMinute = random.nextInt(60);

  TimeOfDay start = TimeOfDay(hour: randomHour, minute: randomMinute);
  TimeOfDay end = TimeOfDay(hour: randomHour, minute: randomMinute+15);
  if(end.minute > 60){
    end.hour + 1;
    end.minute - 60;
  }

  // TimeOfDay start = TimeOfDay(hour: 8, minute: 00);
  // TimeOfDay end = TimeOfDay(hour: 8, minute: 59);

  // TimeOfDay random = TimeOfDay(hour: 15, minute: 30);
  // TimeOfDay now = TimeOfDay.now();
  // double randomTime(TimeOfDay random) => random.hour + random.minute/60;

  double startTime(TimeOfDay start) => start.hour + start.minute/60;
  double endTime(TimeOfDay end) => end.hour + end.minute/60;

  randomTimes.add(startTime(start));
  randomTimes.add(endTime(end));

  return randomTimes;
}

