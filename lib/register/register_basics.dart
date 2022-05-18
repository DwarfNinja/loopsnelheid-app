import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/register/form_button.dart';
import 'package:loopsnelheidapp/register/input_field.dart';
import 'package:loopsnelheidapp/sidebar.dart';

import '../models/user.dart';
import '../services/shared_preferences_service.dart';

class RegisterBasics extends StatefulWidget {
  const RegisterBasics({Key? key}) : super(key: key);

  @override
  State<RegisterBasics> createState() => _RegisterBasicsState();
}

class _RegisterBasicsState extends State<RegisterBasics> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    onPressedNextButton() {
      final user = User(emailController.text, passwordController.text);
      sharedPreferencesService.setObject("user", user);
      Navigator.pushNamed(context, "/register_details");
    }

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
              style:
                  app_theme.textTheme.headline3!.copyWith(color: Colors.white),
            ),
            const Icon(
              Icons.directions_walk,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 10),
            Container(
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
                    InputField(
                        controller: emailController,
                        text: "E-mailadres",
                        hint: "Voer hier uw e-mailadres in"),
                    const SizedBox(height: 20),
                    InputField(
                        controller: passwordController,
                        text: "Wachtwoord",
                        hint: "Voer hier uw wachtwoord in",
                        private: true),
                    const SizedBox(height: 20),
                    InputField(
                        controller: passwordConfirmationController,
                        mustBeTheSame: passwordController,
                        text: "Bevestig wachtwoord",
                        hint: "Herhaal het wachtwoord",
                        private: true),
                    const SizedBox(height: 25),
                    FormButton(text: "Volgende", color: app_theme.blue, onPressed: () => onPressedNextButton()),
                    const SizedBox(height: 15),
                    FormButton(
                        text: "Ga Terug",
                        color: app_theme.white,
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, "/"))
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
