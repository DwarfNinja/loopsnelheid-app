import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class CheckboxLine extends StatelessWidget {

  final String text;
  final bool value;
  final Function(bool?) onChanged;

  const CheckboxLine({Key? key, required this.text, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 25,
          child: Transform.scale(
            scale: 1.25,
            child: Checkbox(
                side: const BorderSide(color: app_theme.grey, width: 2),
                checkColor: app_theme.white,
                fillColor: MaterialStateProperty.all(app_theme.blue),
                value: value,
                onChanged: onChanged
            ),
          ),
        ),
        Text(text, style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 13,color: app_theme.grey))
      ]
    );
  }
}


