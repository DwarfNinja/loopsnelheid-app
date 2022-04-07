import 'package:flutter/material.dart';

import 'app_theme.dart' as app_theme;

class AverageSpeedCard extends StatefulWidget {
  final String header;
  final String speed;

  const AverageSpeedCard({Key? key, required this.header, required this.speed})
      : super(key: key);

  @override
  State<AverageSpeedCard> createState() => _AverageSpeedCardState();
}

class _AverageSpeedCardState extends State<AverageSpeedCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.header,
            style: app_theme.textTheme.bodyText1!.copyWith(color: Colors.white),
            textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Container(
          height: 80.0,
          width: 100.0,
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: [
                app_theme.bottomBoxShadow,
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.speed,
                    style: app_theme.textTheme.headline4,
                    textAlign: TextAlign.center),
                Text("km/h",
                    style: app_theme.textTheme.subtitle1,
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
