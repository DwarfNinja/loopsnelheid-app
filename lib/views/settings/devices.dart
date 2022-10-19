import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/models/device.dart';

import 'package:loopsnelheidapp/widgets/info_base.dart';

import 'package:loopsnelheidapp/services/api/device_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/widgets/info_base.dart';

class Devices extends StatefulWidget {

  const Devices({Key? key})
      : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  DeviceService deviceService = DeviceService();

  late Future<List<Device>> listDevicesFuture;

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
        future: listDevicesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
          if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: app_theme.white,
                  color: app_theme.blue),
            );
          }
          snapshot.data!.sort((Device a, Device b) => a.id.compareTo(b.id));
          return DataTable(
              columns: const [
                DataColumn(
                  label: Text('Apparaat'),
                ),
                DataColumn(
                  label: Expanded(child: Center(child: Text('Actie', textAlign: TextAlign.center))),
                )
              ],
              rows: List.generate(
                snapshot.data!.length,
                    (index) {
                  Device device = snapshot.data![index];
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(device.model),
                            Text(device.type == "READING_DEVICE" ? "Leesapparaat" : "Meetapparaat")
                          ],
                        )
                      ),
                      DataCell(
                        Center(
                          child: IconButton(
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
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ).toList());
        },
      )
    );
  }
}
