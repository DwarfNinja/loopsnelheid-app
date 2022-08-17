import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'package:loopsnelheidapp/widgets/register/form_button.dart';
import 'package:loopsnelheidapp/widgets/register/input_field.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/models/user.dart';
import 'package:loopsnelheidapp/widgets/register/register_base.dart';

class RegisterBasics extends StatefulWidget {
  const RegisterBasics({Key? key}) : super(key: key);

  @override
  State<RegisterBasics> createState() => _RegisterBasicsState();
}

class _RegisterBasicsState extends State<RegisterBasics> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    onPressedNextButton() {
      setState(() => submitted = true);
      if (formKey.currentState!.validate()) {
        final user = User(emailController.text, passwordController.text);
        sharedPreferencesService.setObject("registerUser", user);
        Navigator.pushNamed(context, "/register_details");
      }
    }

    return RegisterBase(
        formKey: formKey,
        submitted: submitted,
        firstButton: FormButton(
            text: "Volgende",
            color: app_theme.blue,
            onPressed: () => onPressedNextButton()),
        secondButton: FormButton(
            text: "Ga Terug",
            color: app_theme.white,
            onPressed: () => Navigator.pop(context)),
        children: [
          Text(
              "Registreren",
              style: app_theme.textTheme.headline5),
          const SizedBox(height: 10),
          Text(
              "Vul uw gegevens hieronder in",
              style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 15, color: app_theme.grey)),
          const SizedBox(height: 20),
          InputField(
              controller: emailController,
              text: "E-mailadres",
              hint: "Voer hier uw e-mailadres in",
              validatorFunction: ValidatorFunction(
                  regex: RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$'),
                  function: null,
                  message: "Moet een geldig e-mailadres zijn")),
          const SizedBox(height: 15),
          InputField(
              controller: passwordController,
              text: "Wachtwoord",
              hint: "Voer hier uw wachtwoord in",
              private: true,
              minLength: 7),
          const SizedBox(height: 15),
          InputField(
              controller: passwordConfirmationController,
              mustBeSameAsText: passwordController,
              text: "Bevestig wachtwoord",
              hint: "Herhaal het wachtwoord",
              private: true,
              minLength: 7),
        ]
    );
  }
}
