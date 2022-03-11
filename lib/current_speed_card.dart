import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentSpeedCard extends StatefulWidget {
  final String speed;

  const CurrentSpeedCard({Key? key, required this.speed})
      : super(key: key);

  @override
  _CurrentSpeedCardState createState() => _CurrentSpeedCardState();
}

class _CurrentSpeedCardState extends State<CurrentSpeedCard> {
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
          BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 8),
              blurRadius: 4),
        ],
      ),
      child: CustomPaint(
        painter: CirclePainter(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.speed,
                style: GoogleFonts.lato(
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF2F23C1),
                          Color(0xFF0FBDF4)
                        ],
                      ).createShader(const Rect.fromLTWH(0, 260, 0, 200))
                ),
              ),
              Text(
                "km/h",
                style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF2F23C1),
                          Color(0xFF0FBDF4)
                        ],
                      ).createShader(const Rect.fromLTWH(0, 325, 0, 200))
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
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2F23C1),
          Color(0xFF0FBDF4)
        ],
      ).createShader(const Rect.fromLTWH(0, -100, 0, 500)
      )
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      115,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}