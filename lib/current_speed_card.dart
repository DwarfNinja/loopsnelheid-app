import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'app_theme.dart' as app_theme;

class CurrentSpeedCard extends StatefulWidget {
  final String speed;

  const CurrentSpeedCard({Key? key, required this.speed})
      : super(key: key);

  @override
  _CurrentSpeedCardState createState() => _CurrentSpeedCardState();
}

class _CurrentSpeedCardState extends State<CurrentSpeedCard> {

  final lightBlueGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2F23C1),
      Color(0xFF0FBDF4)
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 325,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        boxShadow: [
          app_theme.bottomBoxShadow,
        ],
      ),
      child: CustomPaint(
        painter: CirclePainter(gradient: lightBlueGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.speed,
                style: app_theme.textTheme.headline2!.copyWith(
                  foreground: Paint()
                    ..shader = lightBlueGradient.createShader(const Rect.fromLTWH(0, 260, 0, 200)),
                ),
              ),
              Text(
                "km/h",
                style: app_theme.textTheme.headline6!.copyWith(
                  foreground: Paint()
                    ..shader = lightBlueGradient.createShader(const Rect.fromLTWH(0, 325, 0, 200)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color? color;
  final Gradient? gradient;

  CirclePainter({this.color, this.gradient})
      : assert((color != null || gradient != null),
  "One of the parameters must be provided",
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;
    if (gradient != null) {
      paint.shader = gradient!.createShader(const Rect.fromLTWH(0, -100, 0, 500));
    }
    else {
      paint.color = color!;
    }

    canvas.drawCircle(
      center,
      115,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}