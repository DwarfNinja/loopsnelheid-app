import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/sidebar_button.dart';

class SideBar extends StatelessWidget {

  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: app_theme.blue
                        ),
                        width: 90,
                        height: 90,
                        child: const Icon(Icons.directions_walk, size: 60, color: app_theme.white),
                      ),
                      const SizedBox(width: 130),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded, size: 50),
                            padding: EdgeInsets.zero),
                          Text("Sluiten", style: app_theme.textTheme.bodyText2)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 110),
                  const SideBarButton(iconData: Icons.home, text: "Dashboard"),
                  const SizedBox(height: 50),
                  const SideBarButton(iconData: Icons.settings, text: "Instellingen"),
                  const SizedBox(height: 50),
                  const SideBarButton(iconData: Icons.support, text: "Help"),
                  const SizedBox(height: 50),
                  const SideBarButton(iconData: Icons.info, text: "Over"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
