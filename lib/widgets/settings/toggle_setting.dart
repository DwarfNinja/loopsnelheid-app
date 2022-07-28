import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:shared_preferences/shared_preferences.dart';

class ToggleSetting extends StatefulWidget {

  const ToggleSetting({Key? key, required this.text, required this.setting, this.onToggle}) : super(key: key);
  final String text;
  final String setting;
  final Function(bool)? onToggle;

  @override
  State<ToggleSetting> createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<ToggleSetting> {

  bool status = false;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }

  void loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      status = prefs.getBool(widget.setting) ?? false;
    });
  }

  void setSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool(widget.setting, status);
      widget.onToggle!(status);
    });
  }

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
          activeText: "Aan",
          inactiveText: "Uit",
          activeColor: app_theme.green,
          inactiveColor: app_theme.red,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              status = val;
              setSetting();
              },
            );
          },
        ),
      ],
    );
  }
}
