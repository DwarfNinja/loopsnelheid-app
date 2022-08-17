import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/widgets/settings/settings_button.dart';
import 'package:loopsnelheidapp/widgets/settings/toggle_setting.dart';

import 'package:loopsnelheidapp/services/location/location_service.dart';
import 'package:loopsnelheidapp/services/router/navigation_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/services/api/export_service.dart';
import 'package:loopsnelheidapp/services/api/research_service.dart';
import 'package:loopsnelheidapp/services/setting/setting_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

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

    bool isAdministrator = false;
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
        onPressed: () => NavigationService.executeRoute(context, "/"),
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
            Column(
              children: [
                IconButton(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  iconSize: 38,
                  onPressed: () {
                    _globalKey.currentState?.openDrawer();
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
                    "Instellingen",
                    style: app_theme.textTheme.headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  const Icon(
                    Icons.settings,
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45, right: 45),
                      child: Column(
                        children:  [
                          const SizedBox(height: 50),
                          const ToggleSetting(
                              text: "Metingen",
                              setting: "measures",
                              ),
                          const SizedBox(height: 25),
                          ToggleSetting(
                              text: "[Test]\nHandmatig Meten",
                              setting: "manual_measure",
                              onToggle: (bool status) {
                                SettingService.getMeasureSetting().then((value) async {
                                  bool measurePermitted = await SettingService.isMeasureDevice();
                                  if(value == true && measurePermitted) {
                                    status ? LocationService.startLocationService() : LocationService.stopLocationService();
                                  }
                                });
                              }),
                          const SizedBox(height: 50),
                          SettingsButton(
                            iconData: Icons.devices,
                            text: "Mijn apparaten",
                            onPressed: (){
                              NavigationService.executeRoute(context, "/devices");
                            },
                          ),
                          const SizedBox(height: 20),
                          SettingsButton(
                            iconData: Icons.cloud_download,
                            text: "Exporteer gegevens",
                            onPressed: (){
                              exportDataButtonOnPressed();
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<bool>(
                            future: isAdministrator(),
                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                              if(snapshot.data != null && snapshot.data == true) {
                                return
                                  SettingsButton(
                                    iconData: Icons.download,
                                    text: "Exporteer onderzoek",
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
}
