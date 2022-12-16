import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/models/device.dart';
import 'package:loopsnelheidapp/services/notification_service.dart';

import 'package:loopsnelheidapp/widgets/info_base.dart';
import 'package:loopsnelheidapp/widgets/account/account_button.dart';

import 'package:loopsnelheidapp/services/api/device_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/services/api/login_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Devices extends StatefulWidget {

  const Devices({Key? key})
      : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  DeviceService deviceService = DeviceService();

  late Future<List<Device>> listDevicesFuture;

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    listDevicesFuture = deviceService.getDevices();
    setDeviceType();
  }

  void setDeviceType() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    Device thisDevice;
    listDevicesFuture.then((deviceList) => {
      thisDevice = deviceList.firstWhere((device) => device.session == sharedPreferencesService.getString("device_session")),
      if (thisDevice.type != sharedPreferencesService.getString("device_type")) {
        sharedPreferencesService.setString("device_type", thisDevice.type),
      }
    });
  }

  Future<String> getDeviceSession() async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    return sharedPreferencesService.getString("device_session");
  }

  void refreshList() {
    setState(() {
      listDevicesFuture = deviceService.getDevices();
    });
    setDeviceType();
  }

  @override
  Widget build(BuildContext context) {

    return InfoBase(
      pageName: "Apparaten",
      pageIcon: Icons.devices_rounded,
      child: FutureBuilder(
        initialData: const <Device>[],
        future: Future.wait([listDevicesFuture, getDeviceSession()]),
        builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: app_theme.white,
                  color: app_theme.blue),
            );
          }
          List<Device> deviceList = snapshot.data![0] as List<Device>;
          String deviceSession = snapshot.data![1] as String;
          deviceList.sort((Device a, Device b) => a.id.compareTo(b.id));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataTable(
                  columns: const [
                    DataColumn(
                      label: Text('Apparaat'),
                    ),
                    DataColumn(
                      label: Expanded(child: Text('Meet\nApparaat', textAlign: TextAlign.center)),
                    )
                  ],
                  rows: List.generate(
                    deviceList.length,
                        (index) {
                      Device device = deviceList[index];
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(device.model, overflow: TextOverflow.ellipsis,),
                                Text(device.type == "READING_DEVICE" ? "Leesapparaat" : "Meetapparaat")
                              ],
                            )
                          ),
                          DataCell(
                            Center(
                              child: getIconButton(device, deviceSession),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList()),
              Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      AccountButton(
                        buttonSize: const Size(310, 50),
                        iconData: editMode ? Icons.close_rounded : Icons.edit_rounded,
                        text: "Apparaten verwijderen",
                        color: app_theme.blue,
                        onPressed: () => setState(() {
                          editMode = !editMode;
                        }),
                      ),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }

  StatelessWidget getIconButton(Device device, String thisSession) {
    if (editMode) {
      if (device.session == thisSession) {
        return Container();
      }
      else {
        return IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 34, color: app_theme.blue),
            onPressed: () {
              NotificationService.showAlert(
                  context,
                  AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Text("Apparaat verwijderen?", style: app_theme.textTheme.headline6!.copyWith(fontSize: 21)),
                    content: Text(
                        "Weet u zeker dat u apparaat: ${device.model} wilt verwijderen?",
                        style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.grey, fontSize: 15)),
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            "Nee",
                            textAlign: TextAlign.end,
                            style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.blue)),
                      ),
                      TextButton(
                        onPressed: () => logoutDevice(device).then((value) {
                          Navigator.pop(context);
                          refreshList();
                        }),
                        child: Text(
                            "Ja",
                            textAlign: TextAlign.end,
                            style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.blue)),
                      ),
                    ],
                  ));
            }
        );
      }
    }
    else {
      return IconButton(
        icon: device.type == "READING_DEVICE" ? const Icon(
            Icons.check_box_outline_blank_rounded, size: 28, color: app_theme.blue)
            : const Icon(Icons.check_box, size: 28, color: app_theme.blue),
        onPressed: () {
          deviceService.markDeviceAsMeasureDevice(device.session).then((success) => {
            if (success) {
              refreshList()
            }
          });
        },
      );
    }
  }

  Future<Future<bool>> logoutDevice(Device device) async {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.getSharedPreferenceInstance();

    LoginService loginService = LoginService();
    return loginService.logoutDevice(sharedPreferencesService.getString("token"), device.session);
  }
}
