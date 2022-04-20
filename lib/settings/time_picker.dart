import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';

List maakTimeSpan(_randomHour){
    var randomTijden = [];

    Random random = Random();

    int _randomMinute = random.nextInt(60);

    TimeOfDay start = TimeOfDay(hour: _randomHour, minute: _randomMinute);
    TimeOfDay eind = TimeOfDay(hour: _randomHour, minute: _randomMinute+15);
    if(eind.minute > 60){
        eind.hour + 1;
        eind.minute - 60;
    }

    double startTime(TimeOfDay start) => start.hour + start.minute/60;
    double eindTime(TimeOfDay eind) => eind.hour + eind.minute/60;

    randomTijden.add(startTime(start));
    randomTijden.add(eindTime(eind));

    return randomTijden;

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

List setRandomTijden(){
    var randomTijden = [];

    Random random = Random();

    int _randomOchtendHour = 8 + random.nextInt(12 - 8);
    int _randomMiddagHour = 13 + random.nextInt(17 - 13);

    randomTijden.add(maakTimeSpan(_randomOchtendHour));
    randomTijden.add(maakTimeSpan(_randomMiddagHour));

    return randomTijden;

}
