import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/services/api/export_service.dart';
import 'package:loopsnelheidapp/services/api/research_service.dart';
import 'package:loopsnelheidapp/services/measure/background_service.dart';
import 'package:loopsnelheidapp/services/notification_service.dart';
import 'package:loopsnelheidapp/services/router/navigation_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/widgets/info_base.dart';
import 'package:loopsnelheidapp/widgets/notification/custom_alert.dart';
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

    showExportDataAlertDialog() {
      NotificationService.showAlert(
          context,
          CustomAlert(
            titleText: "Data Exporteren...",
            messageText:"Uw data is aan het exporteren, u zult het binnen 2 minuten via uw mail ontvangen.",
            buttonText: "Ok", onPressed: () => Navigator.pop(context),
          ),
          dismissable: false
      );
    }

    exportData() {
      exportService.requestExportData();
      showExportDataAlertDialog();
    }

    exportAllData() {
      isAdministrator().then((value) => {
        if (value) {
          researchService.getStatistics().then((value) => {
            if (value == 200) {
              showExportDataAlertDialog()
            }
          })
        }
      });
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
              onPressed: () => exportData(),
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
                      onPressed: () => exportAllData(),
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
