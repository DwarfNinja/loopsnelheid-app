import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/register/form_button.dart';
import 'package:loopsnelheidapp/register/input_field.dart';

import 'package:loopsnelheidapp/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import '../services/login_service.dart';
import '../services/shared_preferences_service.dart';

class Login extends StatefulWidget {

  const Login({Key? key})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool submitted = false;
  bool stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    userAuthenticate() {
      LoginService loginService = LoginService();
      return loginService.authenticate(emailController.text, passwordController.text);
    }

    handleAuthenticateResponse(response) {
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body!);
        sharedPreferencesService.setString("token", body['access_token']);

        Navigator.pushNamed(context, "/");
      } else if (response.statusCode == 401) {
        alertDialog(context);
      }
    }

    onPressedLoginButton() {
      userAuthenticate().then((response) => handleAuthenticateResponse(response));
    }

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
                      InputField(
                          controller: emailController,
                          text: "E-mailadres", hint: "Voer hier uw e-mailadres in"
                      ),
                      const SizedBox(height: 20),
                      InputField(
                          controller: passwordController,
                          text: "Wachtwoord",
                          hint: "Voer hier uw wachtwoord in",
                          private: true
                      ),
                      const SizedBox(height: 25),
                      FormButton(
                          text: "Inloggen",
                          color: app_theme.blue,
                          onPressed: () {
                            setState(() => submitted = true);
                            if (formKey.currentState!.validate()) {
                              onPressedLoginButton();
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