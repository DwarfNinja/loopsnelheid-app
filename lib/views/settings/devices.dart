import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Devices extends StatefulWidget {

  const Devices({Key? key})
      : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

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
                  SizedBox(height: 70),
                  Text(
                    "Mijn apparaten",
                    style: app_theme.textTheme.headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container (
                    width: width,
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
                    child: Stack(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(
                              label: Container(
                                width: 60,
                                child: Text('Apparaat'),
                              )
                            ),
                            DataColumn(
                                label: Container(
                                  width: 30,
                                  child: Text('Type'),
                                )
                            ),
                            DataColumn(
                              label: Container(
                                width: 50,
                                child: Text('Actie'),
                              ),
                            )
                          ],
                          rows: [
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(
                                    Text('Android')
                                ),
                                const DataCell(
                                    Text('Meetapparaat')
                                ),
                                DataCell(
                                  TextButton(
                                    child: Icon(Icons.check),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(
                                    Text('Android')
                                ),
                                const DataCell(
                                    Text('Meetapparaat')
                                ),
                                DataCell(
                                  TextButton(
                                    child: Icon(Icons.check),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            )
                          ]
                        ),
                      ],
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
