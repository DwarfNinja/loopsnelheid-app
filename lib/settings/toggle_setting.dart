import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class ToggleSetting extends StatefulWidget {

  const ToggleSetting({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  State<ToggleSetting> createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<ToggleSetting> {

  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            widget.text,
            style: app_theme.textTheme.bodyText1,
            textAlign: TextAlign.center),
        const SizedBox(width: 50),
        FlutterSwitch(
          width: 60,
          height: 30,
          valueFontSize: 10,
          toggleSize: 25,
          value: status,
          activeColor: app_theme.green,
          inactiveColor: app_theme.red,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              status = val;
            },
            );
          },
        ),
      ],
    );
  }
}