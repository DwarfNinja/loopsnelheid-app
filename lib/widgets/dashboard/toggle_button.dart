import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class ToggleButton extends StatefulWidget {

  const ToggleButton({Key? key, required this.activeText, required this.inactiveText, required this.onToggle, required this.value}) : super(key: key);
  final String activeText;
  final String inactiveText;
  final Function(bool) onToggle;
  final bool value;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
          width: 180,
          height: 45,
          valueFontSize: 25,
          toggleSize: 40,
          padding: 5,
          value: widget.value,
          activeText: widget.activeText,
          inactiveText: widget.inactiveText,
          activeColor: app_theme.blue,
          inactiveColor: app_theme.blue,
          showOnOff: true,
          onToggle: widget.onToggle,
        );
  }
}