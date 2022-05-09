import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/register/form_button.dart';
import 'package:loopsnelheidapp/register/input_field.dart';

import 'package:loopsnelheidapp/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'checkbox_line.dart';

class RegisterBasics extends StatefulWidget {

  const RegisterBasics({Key? key})
      : super(key: key);

  @override
  State<RegisterBasics> createState() => _RegisterBasicsState();
}

class _RegisterBasicsState extends State<RegisterBasics> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool termsAndConditions = false;
  bool privacyStatement = false;
  bool olderThanSixteen = false;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            Text(
              "Loopsnelheid",
              style: app_theme.textTheme.headline3!
                  .copyWith(color: Colors.white),
            ),
            const Icon(
              Icons.directions_walk,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 10),
            Container (
              width: double.infinity,
              height: 650,
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
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const InputField(text: "E-mailadres", hint: "Voer hier uw e-mailadres in"),
                    const SizedBox(height: 20),
                    const InputField(text: "Wachtwoord", hint: "Voer hier uw wachtwoord in", private: true),
                    const SizedBox(height: 20),
                    const InputField(text: "Bevestig wachtwoord", hint: "Herhaal het wachtwoord", private: true),
                    const SizedBox(height: 20),
                    CheckboxLine(
                      text: "Ik ga akkoord met de algemene voorwaarden",
                      value: termsAndConditions,
                      onChanged: (bool? value) => setState(() => termsAndConditions = !termsAndConditions),
                    ),
                    const SizedBox(height: 15),
                    CheckboxLine(
                      text: "Ik ga akkoord met de privacy verklaring",
                      value: privacyStatement,
                      onChanged: (bool? value) => setState(() => privacyStatement = !privacyStatement),
                    ),
                    const SizedBox(height: 15),
                    CheckboxLine(
                      text: "Ik ben ouder dan 16 jaar of heb toestemming \n van een ouder/voogd",
                      value: olderThanSixteen,
                      onChanged: (bool? value) => setState(() => olderThanSixteen = !olderThanSixteen),
                    ),
                    const SizedBox(height: 25),
                    FormButton(text: "Volgende", onPressed: () => null)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}