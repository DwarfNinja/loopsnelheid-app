import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/services/api/profile_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/widgets/register/form_button.dart';
import 'package:loopsnelheidapp/widgets/register/input_field.dart';
import 'package:loopsnelheidapp/widgets/register/register_base.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    onPressedSendButton() {
      ProfileService.forgotPassword(emailController.text);
    }

    return RegisterBase(
        formKey: formKey,
        submitted: submitted,
        firstButton: FormButton(
            text: "Versturen",
            color: app_theme.blue,
            onPressed: () {
              setState(() => submitted = true);
              if (formKey.currentState!.validate()) {
                onPressedSendButton();
              }
            }),
        secondButton: FormButton(
            text: "Ga Terug",
            color: app_theme.white,
            onPressed: () => Navigator.pop(context)),
        buttonSpacing: 15,
        children: [
          Text(
              "Wachtwoord vergeten",
              style: app_theme.textTheme.headline5),
          const SizedBox(height: 10),
          Text(
              "Vul uw e-mailadres in om een email te ontvangen met stappen om een nieuw wachtwoord te verkrijgen",
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
          )
        ]
    );
  }
}