import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/widgets/register/form_button.dart';
import 'package:loopsnelheidapp/widgets/register/input_field.dart';
import 'package:loopsnelheidapp/widgets/register/register_base.dart';

import 'package:loopsnelheidapp/services/api/login_service.dart';
import 'package:loopsnelheidapp/services/device_info_service.dart';
import 'package:loopsnelheidapp/services/setting/setting_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Login extends StatefulWidget {

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool submitted = false;
  bool stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    userAuthenticate() async {
      LoginService loginService = LoginService();
      DeviceInfoService deviceInfoService = DeviceInfoService();

      await deviceInfoService.initPlatform();

      return loginService.login(emailController.text, passwordController.text, deviceInfoService.os!, deviceInfoService.model!);
    }

    handleAuthenticateResponse(response) {
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body!);
        sharedPreferencesService.setString("token", body['access_token']);
        sharedPreferencesService.setObject("roles", body['roles']);
        sharedPreferencesService.setString("device_session", body['device']['session']);
        sharedPreferencesService.setString("device_type", body['device']['type']);
        SettingService.isMeasureDevice().then((isMeasureDevice) {
          sharedPreferencesService.setBool("measures", isMeasureDevice);
        });
        Navigator.pushNamed(context, "/");
      } else if (response.statusCode == 401) {
        alertDialog(context);
      }
    }

    handleAuthenticateError(error) {
      alertDialog(context);
    }

    onPressedLoginButton() {
      userAuthenticate().then((response) => handleAuthenticateResponse(response)).catchError((error) => handleAuthenticateError(error));
    }

    return RegisterBase(
        formKey: formKey,
        submitted: submitted,
        firstButton: FormButton(
            text: "Inloggen",
            color: app_theme.blue,
            onPressed: () {
              setState(() => submitted = true);
              if (formKey.currentState!.validate()) {
                onPressedLoginButton();
              }
            }),
        secondButton: FormButton(text: "Registreren", color: app_theme.white, onPressed: () => Navigator.pushNamed(context, "/register_basics")),
        buttonSpacing: 15,
        children: [
          Text(
              "Login",
              style: app_theme.textTheme.headline5),
          const SizedBox(height: 10),
          Text(
              "Login met u huidige account of maak een nieuwe account aan",
              textAlign: TextAlign.center,
              style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 15, color: app_theme.grey)),
          const SizedBox(height: 20),
          InputField(
              controller: emailController,
              text: "E-mailadres", hint: "Voer hier uw e-mailadres in",
              validatorFunction: ValidatorFunction(
                  regex: RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$'),
                  function: null,
                  message: "Niet een geldig e-mailadres")
          ),
          const SizedBox(height: 25),
          InputField(
              controller: passwordController,
              text: "Wachtwoord",
              hint: "Voer hier uw wachtwoord in",
              private: true
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(5, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              onPressed: () {
                Navigator.pushNamed(context, "/forgot_password");
              },
              child: Text('Wachtwoord vergeten', style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.blue)),
            ),
          )
        ]
    );
  }
}

void alertDialog(BuildContext context) {
  var alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
          "Inloggen niet gelukt",
          style: app_theme.textTheme.headline5!
              .copyWith(color: app_theme.red)
      ),
      content: Text(
          'Controleer uw e-mailadres en/of wachtwoord',
          style: app_theme.textTheme.bodyText2!
              .copyWith(color: app_theme.black)
      ),
      backgroundColor: app_theme.white,
      alignment: AlignmentDirectional.topCenter,
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
                'Melding sluiten',
                style: app_theme.textTheme.bodyText2!
                    .copyWith(color: app_theme.blue, fontSize: 14))
        ),
      ]
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
  );
}
