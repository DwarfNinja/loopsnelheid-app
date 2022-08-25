import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/models/device.dart';

import 'package:loopsnelheidapp/services/api/device_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/widgets/info_base.dart';

class Devices extends StatefulWidget {

  const Devices({Key? key})
      : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  Future<List<Device>>? listDevicesFuture;
  DeviceService deviceService = DeviceService();

  @override
  void initState() {
    super.initState();
    listDevicesFuture = deviceService.getDevices();
  }

  void refreshList() {
    setState(() {
      listDevicesFuture = deviceService.getDevices();
    });
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
          return DataTable(
              columns: const [
                DataColumn(
                  label: Text('Apparaat'),
                ),
                DataColumn(
                  label: Text('Actie'),
                )
              ],
              rows: List.generate(
                snapshot.data!.length,
                    (index) {
                  var device = snapshot.data![index];
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                          SizedBox(
                              width: 200,
                              child: RichText(
                                text: TextSpan(
                                  text: device.model + '\n',
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                        text: device.type == "READING_DEVICE" ? "Leesapparaat" : "Meetapparaat",
                                        style: const TextStyle(fontSize: 16)
                                    ),
                                  ],
                                ),
                              )
                          )
                      ),
                      DataCell(
                        TextButton(
                          child: const Icon(Icons.check),
                          onPressed: () {
                            deviceService.markDeviceAsMeasureDevice(device.session).then((success) => {
                              if (success) {
                                refreshList()
                              }
                            });
                          },
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
