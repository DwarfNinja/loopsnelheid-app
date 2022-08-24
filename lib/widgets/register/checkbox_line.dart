import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class CheckboxLine extends StatefulWidget {

  final String text;
  final bool value;
  final Function(bool?) onChanged;
  final Color textColor;
  final bool submitted;

  const CheckboxLine({Key? key, required this.text, required this.value, required this.onChanged, this.textColor = app_theme.grey, required this.submitted}) : super(key: key);

  @override
  State<CheckboxLine> createState() => CheckboxLineState();
  }

class CheckboxLineState extends State<CheckboxLine> {

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
                value: widget.value,
                onChanged: widget.onChanged
            ),
          ),
        ),
        Text(widget.text,
            style: app_theme.textTheme.bodyText2!.copyWith(
                fontSize: 13, 
                color: widget.value || (!widget.value && !widget.submitted) || (widget.value && widget.submitted) ? widget.textColor : app_theme.red))
      ]
    );
  }
}


