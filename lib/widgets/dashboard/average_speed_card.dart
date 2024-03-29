import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class AverageSpeedCard extends StatefulWidget {
  final String header;
  final double speed;
  final bool loadingIndicator;

  const AverageSpeedCard({Key? key, required this.header, required this.speed, this.loadingIndicator = false})
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
            child: widget.loadingIndicator ? const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: app_theme.white,
                  color: app_theme.blue),
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.speed.toStringAsFixed(1),
                    style: app_theme.textTheme.headline5,
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
