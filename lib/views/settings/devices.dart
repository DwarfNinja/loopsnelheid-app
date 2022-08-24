import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/models/device.dart';

import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/services/api/device_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Devices extends StatefulWidget {

  const Devices({Key? key})
      : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Future<List<Device>>? _listDevicesFuture;
  DeviceService deviceService = DeviceService();

  @override
  void initState() {
    super.initState();
    _listDevicesFuture = deviceService.getDevices();
  }

  void refreshList() {
    setState(() {
      _listDevicesFuture = deviceService.getDevices();
    });
  }

  @override
  Widget build(BuildContext context) {

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
                    "Mijn apparaten",
                    style: app_theme.textTheme.headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  const Icon(
                    Icons.devices_rounded,
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
                    child: FutureBuilder(
                      initialData: const <Device>[],
                      future: _listDevicesFuture,
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
