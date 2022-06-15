import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/services/api/login_service.dart';
import 'package:loopsnelheidapp/widgets/sidebar/sidebar_button.dart';

String currentRoute = "/";

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
                      Container( //TODO: To be replaced for app icon
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
                    onPressed: () => executeRoute(context, "/"),
                  ),
                  const SizedBox(height: 50),
                  SideBarButton(
                    iconData: Icons.settings,
                    text: "Instellingen",
                    onPressed: () => executeRoute(context, "/settings"),
                  ),
                  const SizedBox(height: 50),
                  SideBarButton(
                    iconData: Icons.support,
                    text: "Help",
                    onPressed: () => executeRoute(context, "/login"),
                  ),
                  const SizedBox(height: 50),
                  SideBarButton(
                    iconData: Icons.info,
                    text: "Over",
                    onPressed: () => executeRoute(context, "/login"),
                  ),
                  const SizedBox(height: 50),
                  SideBarButton(
                    iconData: Icons.logout,
                    text: "Afmelden",
                    onPressed: () => logoutUser(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void executeRoute(BuildContext context, String name) {
    if (currentRoute != name) {
      Navigator.pushReplacementNamed(context, name);
    }
    else {
      Navigator.pop(context);
    }
    currentRoute = name;
  }

  void logoutUser()
  {
    LoginService loginService = LoginService();
    loginService.logout().then((value) => {
      if (value) {
        executeRoute(context, "/login")
      }
    });
  }
}
