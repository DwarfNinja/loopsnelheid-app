import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class LegendText extends StatelessWidget {

  final String text;
  final Color color;

  const LegendText({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(text, style: app_theme.textTheme.bodyText2),
        ],
      ),
    );
  }
}