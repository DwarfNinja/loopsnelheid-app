import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/register/form_button.dart';
import 'package:loopsnelheidapp/register/input_field.dart';

import 'package:loopsnelheidapp/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'checkbox_line.dart';

class Login extends StatefulWidget {

  const Login({Key? key})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();

  bool submitted = false;

  bool stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.blue,
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
                child: Form(
                  key: formKey,
                  autovalidateMode: submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const InputField(text: "E-mailadres", hint: "Voer hier uw e-mailadres in"),
                      const SizedBox(height: 20),
                      const InputField(text: "Wachtwoord", hint: "Voer hier uw wachtwoord in", private: true),
                      const SizedBox(height: 25),
                      CheckboxLine(
                          text: "Ingelogd blijven",
                          value: stayLoggedIn,
                          onChanged: (bool? value) => setState(() => stayLoggedIn = !stayLoggedIn)),
                      const SizedBox(height: 50),
                      FormButton(
                          text: "Volgende",
                          color: app_theme.blue,
                          onPressed: () {
                            setState(() => submitted = true);
                            if (formKey.currentState!.validate()) {
                              Navigator.pushNamed(context, "/");
                            }
                          }),
                      const SizedBox(height: 15),
                      FormButton(text: "Registreren", color: app_theme.white, onPressed: () => Navigator.pushNamed(context, "/register_basics"))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}