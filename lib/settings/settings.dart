import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/settings/toggle_setting.dart';

import 'package:loopsnelheidapp/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Settings extends StatefulWidget {

  const Settings({Key? key})
      : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.blue,
      key: _globalKey,
      drawer: const SideBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: app_theme.mainLinearGradient,
        ),
        child: Stack(
          children: [
            IconButton(
              padding: const EdgeInsets.all(20),
              icon: const Icon(Icons.menu),
              color: Colors.white,
              iconSize: 38,
              onPressed: () {
                _globalKey.currentState?.openDrawer();
              },
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Text(
                    "Instellingen",
                    style: app_theme.textTheme.headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container (
                    width: 375,
                    height: 700,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      boxShadow: [
                        app_theme.bottomBoxShadow,
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45, right: 45),
                      child: Column(
                        children: const [
                          SizedBox(height: 50),
                          ToggleSetting(text: "Meten"),
                          SizedBox(height: 20),
                          ToggleSetting(text: "Meldingen"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
