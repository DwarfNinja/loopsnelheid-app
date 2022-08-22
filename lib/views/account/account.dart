import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/services/api/profile_service.dart';

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/views/sidebar/sidebar.dart';

import 'package:loopsnelheidapp/widgets/account/account_line.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Account extends StatefulWidget {

  const Account({Key? key})
      : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Profile profile = Profile(0, "laden...", "laden...", "laden...", false, 0, 0, ["laden.."]);

  void getAccount() async {
    await AccountService.getAccount().then((value) => {
      profile = value
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getAccount();
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
                    "Account",
                    style: app_theme.textTheme.headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  const Icon(
                    Icons.person,
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
                      padding: const EdgeInsets.all(45),
                      child: Column(
                        children: [
                          AccountLine(label: "Email", text: profile.email),
                          const SizedBox(height: 20),
                          const AccountLine(label: "Wachtwoord", text: "●●●●●●●●"),
                          const SizedBox(height: 20),
                          AccountLine(label: "Geboortedatum", text: profile.dateOfBirth),
                          const SizedBox(height: 20),
                          AccountLine(label: "Geslacht", text: profile.sex == "MALE" ? "MAN" : "VROUW"),
                          const SizedBox(height: 20),
                          AccountLine(label: "Lengte", text: profile.height.toString()),
                          const SizedBox(height: 20),
                          AccountLine(label: "Gewicht", text: profile.weight.toString()),
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
