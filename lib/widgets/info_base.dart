import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

class InfoBase extends StatefulWidget {

  final Widget child;
  final String pageName;
  final IconData pageIcon;

  const InfoBase({Key? key, required this.child, required this.pageName, required this.pageIcon})
      : super(key: key);

  @override
  State<InfoBase> createState() => _InfoBaseState();
}

class _InfoBaseState extends State<InfoBase> {

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.blue,
      key: globalKey,
      drawer: const SideBar(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            decoration: const BoxDecoration(
              gradient: app_theme.mainLinearGradient,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      icon: const Icon(Icons.menu),
                      color: Colors.white,
                      iconSize: 38,
                      onPressed: () {
                        globalKey.currentState?.openDrawer();
                      },
                    ),
                    Text("Menu",
                        style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.white)
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Text(
                        widget.pageName,
                        style: app_theme.textTheme.headline3!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Icon(
                        widget.pageIcon,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 20),
                      Container (
                        width: 375,
                        height: 645,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          boxShadow: [
                            app_theme.bottomBoxShadow,
                          ],
                        ),
                        child: widget.child,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
