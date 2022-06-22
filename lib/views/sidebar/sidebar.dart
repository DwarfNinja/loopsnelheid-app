import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/services/api/login_service.dart';
import 'package:loopsnelheidapp/widgets/sidebar/sidebar_button.dart';

import '../../services/router/navigation_service.dart';

class SideBar extends StatefulWidget {

  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

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
                        width: 85,
                        height: 85,
                        child: const Icon(Icons.directions_walk, size: 65, color: app_theme.white),
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
                  SideBarButton(
                    iconData: Icons.home,
                    text: "Dashboard",
                    onPressed: () => NavigationService.executeRoute(context, "/"),
                  ),
                  const SizedBox(height: 50),
                  SideBarButton(
                    iconData: Icons.settings,
                    text: "Instellingen",
                    onPressed: () => NavigationService.executeRoute(context, "/settings"),
                  ),
                  const SizedBox(height: 50),
                  SideBarButton(
                    iconData: Icons.logout,
                    text: "Afmelden",
                    onPressed: () => logoutUser(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logoutUser(BuildContext context)
  {
    LoginService loginService = LoginService();
    loginService.logout().then((value) => {
      if (value) {
        NavigationService.executeRoute(context, "/login")
      }
    });
  }
}
