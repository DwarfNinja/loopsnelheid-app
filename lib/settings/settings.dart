import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';

List setRandomTimes(){
    var randomTimes = [];

    Random random = Random();

    int _randomMorningHour = 8 + random.nextInt(12 - 8);
    int _randomAfternoonHour = 13 + random.nextInt(17 - 13);

    randomTimes.add(setTimeSpan(_randomMorningHour));
    randomTimes.add(setTimeSpan(_randomAfternoonHour));

    return randomTimes;
}

List setTimeSpan(_randomHour){
    var randomTimes = [];

    Random random = Random();

    int _randomMinute = random.nextInt(60);

    TimeOfDay start = TimeOfDay(hour: _randomHour, minute: _randomMinute);
    TimeOfDay end = TimeOfDay(hour: _randomHour, minute: _randomMinute+15);
    if(end.minute > 60){
        end.hour + 1;
        end.minute - 60;
    }

    double startTime(TimeOfDay start) => start.hour + start.minute/60;
    double endTime(TimeOfDay end) => end.hour + end.minute/60;

    randomTimes.add(startTime(start));
    randomTimes.add(endTime(end));

    return randomTimes;

    // TimeOfDay start = TimeOfDay(hour: _randomOchtendHour, minute: _randomMinute);
    // TimeOfDay end = TimeOfDay(hour: _randomMiddagHour, minute: _randomMinute);
    // TimeOfDay now = TimeOfDay.now();
    //
    // double startTime(TimeOfDay start) => start.hour + start.minute/60;
    // double endTime(TimeOfDay end) => end.hour + end.minute/60;
    // double rightNow(TimeOfDay now) => now.hour + now.minute/60.0;
    //
    // randomTijden.add(startTime(start));
    // randomTijden.add(endTime(end));
    // randomTijden.add(rightNow(now));


    // TimeOfDay start = TimeOfDay(hour: 10, minute: 20);
    // TimeOfDay end = TimeOfDay(hour: 10, minute: 55);
    // TimeOfDay random = TimeOfDay(hour: 10, minute: 20);
    //
    //
    // double startTime(TimeOfDay start) => start.hour + start.minute/60;
    // double endTime(TimeOfDay end) => end.hour + end.minute/60;
    // double randomTime(TimeOfDay random) => random.hour + random.minute/60;
    // // double rightNow(TimeOfDay now) => now.hour + now.minute/60.0;
    //
    // randomTijden.add(startTime(start));
    // randomTijden.add(endTime(end));
    // randomTijden.add(randomTime(random));

    // return randomTijden;
}

