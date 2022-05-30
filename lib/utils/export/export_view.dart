

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/widgets/sidebar/sidebar_button.dart';



class ExportView extends StatefulWidget{
  const ExportView({Key? key}) : super(key: key);

  @override
  State<ExportView> createState() => _ExportView();
}

class _ExportView extends State<ExportView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.blue,
      drawer: const SideBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: app_theme.mainLinearGradient
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 25),
              Text(
                "Loopsnelheid",
                style: app_theme.textTheme.headline3!.copyWith(color: Colors.white),
              ),
              const Icon(
                Icons.directions_walk,
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 10),
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
                      SizedBox(height: 50),
                      SideBarButton(
                        iconData: Icons.import_export_rounded,
                        text: "Export Data",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}