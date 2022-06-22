import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/widgets/settings/toggle_setting.dart';
import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/widgets/sidebar/sidebar_button.dart';

import '../../services/api/export_service.dart';
import '../../services/api/research_service.dart';
import '../../utils/shared_preferences_service.dart';

String currentRoute = "/";

class Settings extends StatefulWidget {

  const Settings({Key? key})
      : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  ExportService exportService = ExportService();
  ResearchService researchService = ResearchService();


  Future<bool> isAdministrator() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    var isAdministrator = false;
    await sharedPreferencesService.getObject("roles").then((value) => {
      isAdministrator = value.contains("ROLE_ADMIN")
    });

    return isAdministrator;
  }

  @override
  Widget build(BuildContext context) {

    showAlertDialog(BuildContext context) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () => executeRoute(context, "/"),
      );
      AlertDialog alert = AlertDialog(
        title: const Text("Data Exporteren..."),
        content: const Text("Uw data is aan het exporteren, u zult het binnen 2 minuten via uw mail ontvangen."),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    exportData() {

      exportService.requestExportData();
      showAlertDialog(context);
    }

    exportAllData() {

      isAdministrator().then((value) => {
        if (value) {
          researchService.getStatistics().then((value) => {
            if (value == 200) {
              showAlertDialog(context)
            }
          })
        }
      });
    }
    exportDataButtonOnPressed(){
      exportData();
    }

    exportAllDataButtonOnPressed(){
      exportAllData();
    }

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
                        children:  [
                          const SizedBox(height: 50),
                          const ToggleSetting(
                              text: "Meten",
                              setting: "measure"),
                          const SizedBox(height: 20),
                          const ToggleSetting(
                              text: "Meldingen",
                              setting: "notifications"),
                          const SizedBox(height: 50),
                          SideBarButton(
                            iconData: Icons.next_plan_rounded,
                            text: "Exporteer Gegevens",
                            onPressed: (){
                              exportDataButtonOnPressed();
                            },
                          ),
                          const SizedBox(height: 50),
                          FutureBuilder<bool>(
                            future: isAdministrator(),
                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                              if(snapshot.data != null && snapshot.data == true) {
                                return
                                  SideBarButton(
                                    iconData: Icons.next_plan_rounded,
                                    text: "Export All",
                                    onPressed: (){
                                      exportAllDataButtonOnPressed();
                                    },
                                  );
                              }

                              return Container();
                            },
                          ),
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



  void executeRoute(BuildContext context, String name) {
    if (currentRoute != name) {
      Navigator.pushReplacementNamed(context, name);
    }
    else {
      Navigator.pop(context);
    }
    currentRoute = name;
  }
}


// hier komt de save data
