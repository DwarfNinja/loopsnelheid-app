import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/services/api/export_service.dart';
import 'package:loopsnelheidapp/services/api/research_service.dart';
import 'package:loopsnelheidapp/services/measure/background_service.dart';
import 'package:loopsnelheidapp/services/router/navigation_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/widgets/info_base.dart';
import 'package:loopsnelheidapp/widgets/settings/settings_button.dart';
import 'package:loopsnelheidapp/widgets/settings/toggle_setting.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {

  const Settings({Key? key})
      : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ExportService exportService = ExportService();
  ResearchService researchService = ResearchService();

  Future<bool> isAdministrator() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    bool isAdministrator = sharedPreferencesService.getObject("roles").contains("ROLE_ADMIN");

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

    return InfoBase(
      pageName: "Instellingen",
      pageIcon: Icons.settings,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          children: [
            const SizedBox(height: 50),
            ToggleSetting(
              text: "Metingen",
              setting: "measures",
              initialStatus: true,
              onToggle: (bool status) {
                  status ? BackgroundService.startBackgroundService() : BackgroundService.stopBackgroundService();
              }
            ),
            const SizedBox(height: 50),
            SettingsButton(
              iconData: Icons.devices_rounded,
              text: "Mijn apparaten",
              onPressed: (){
                NavigationService.executeRoute(context, "/devices");
              },
            ),
            const SizedBox(height: 20),
            SettingsButton(
              iconData: Icons.cloud_download_rounded,
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
                      iconData: Icons.download_rounded,
                      text: "Exporteer onderzoek",
                      onPressed: (){
                        exportAllDataButtonOnPressed();
                      },
                    );
                }
                return Container();
              },
            ),
            const Spacer(),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                      "Versie: Error",
                      style: app_theme.textTheme.bodyText1!.copyWith(
                          color: app_theme.black), textAlign: TextAlign.center);
                }
                else if (snapshot.data?.buildNumber != null) {
                  return Text(
                      "Versie: ${snapshot.data?.version} + ${snapshot.data?.buildNumber}",
                      style: app_theme.textTheme.bodyText1!.copyWith(
                          color: app_theme.black), textAlign: TextAlign.center);
                }
                else {
                  return Text(
                      "Versie: ${snapshot.data?.version}",
                      style: app_theme.textTheme.bodyText1!.copyWith(
                          color: app_theme.black), textAlign: TextAlign.center);
                }
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
