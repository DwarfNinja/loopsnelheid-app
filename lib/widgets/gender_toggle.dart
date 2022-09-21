import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class GenderToggle extends StatefulWidget {
  final Function(bool) onToggle;
  final bool value;
  final TextStyle? headerStyle;
  final Size switchSize;
  final double toggleSize;

  const GenderToggle({
    Key? key,
    required this.onToggle,
    required this.value,
    this.headerStyle,
    this.switchSize = const Size(120, 40),
    this.toggleSize = 35
  }) : super(key: key);

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
                "Geslacht",
                style: widget.headerStyle ?? app_theme.textTheme.headline6!.copyWith(color: app_theme.black)
            ),
          ),
        ),
        const SizedBox(width: 25),
        FlutterSwitch(
          width: widget.switchSize.width,
          height: widget.switchSize.height,
          valueFontSize: 18,
          toggleSize: widget.toggleSize,
          value: widget.value,
          activeText: "Vrouw",
          inactiveText: "Man",
          activeIcon: const Icon(Icons.female),
          inactiveIcon: const Icon(Icons.male),
          activeColor: app_theme.red,
          inactiveColor: app_theme.blue,
          showOnOff: true,
          onToggle: widget.onToggle,
        ),
      ],
    );
  }
}