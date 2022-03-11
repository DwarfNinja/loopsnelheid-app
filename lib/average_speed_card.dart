import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AverageSpeedCard extends StatefulWidget {
  final String header;
  final String speed;

  const AverageSpeedCard({Key? key, required this.header, required this.speed})
      : super(key: key);

  @override
  _AverageSpeedCardState createState() => _AverageSpeedCardState();
}

class _AverageSpeedCardState extends State<AverageSpeedCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.header,
            style: GoogleFonts.lato(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
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
                BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 8),
                    blurRadius: 4),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.speed,
                    style: GoogleFonts.lato(
                        fontSize: 28,
                        color: const Color(0xFF01172F),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
                Text("km/h",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: const Color(0xFF01172F),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
