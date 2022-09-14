import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/widgets/info_base.dart';
import 'package:loopsnelheidapp/widgets/account/account_field.dart';
import 'package:loopsnelheidapp/widgets/account/account_button.dart';
import 'package:loopsnelheidapp/widgets/custom_snackbar.dart';

import 'package:loopsnelheidapp/services/api/profile_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class EditBasics extends StatefulWidget {

  const EditBasics({Key? key})
      : super(key: key);

  @override
  State<EditBasics> createState() => _EditBasicsState();
}

class _EditBasicsState extends State<EditBasics> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

  bool submitted = false;

  Future<Profile>? profile;

  Future<Profile> getProfile() async {
    await sharedPreferencesService.getSharedPreferenceInstance();

    if (sharedPreferencesService.containsKey("profile")) {
      dynamic localJsonProfile = sharedPreferencesService.getObject("profile");
      Profile profileFromJson = Profile.fromJson(localJsonProfile);
      setAccountInFields(profileFromJson);
      return Future.value(profileFromJson);
    }

    Future<Profile> response = ProfileService.getAccount();
    response.then((value) => {
      setAccountInFields(value)
    });
    return response;
  }

  void setAccountInFields(Profile profile) {
    setState(() {
      emailController.text = profile.email;
    });
  }

  void onPressedSubmitBasicsChange() {
    if (formKey.currentState!.validate()) {
      if (emailController.text.isNotEmpty) {
        ProfileService.changeEmail(emailController.text).then((response) => {
          if (response == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(messageType: MessageType.success, message: "Success! Uw email is aangepast! Er is een bevestigings mail verstuurt naar uw mailbox!")
            )
          } else if (response == 400) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(messageType: MessageType.error, message: "Fout! Er is iets misgegaan met het aanpassen van u email!")
            )
          }
        });
      }
      if (currentPasswordController.text.isNotEmpty && newPasswordController.text.isNotEmpty) {
        ProfileService.changePassword(currentPasswordController.text, newPasswordController.text)
            .then((response) => {
          if (response == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(messageType: MessageType.success, message: "Success! U wachtwoord is aangepast!")
            )
          } else if (response == 400) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(messageType: MessageType.error, message: "Fout! Er is iets misgegaan met het aanpassen van u wachtwoord!")
            )
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    profile = getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return InfoBase(
      pageName: "Account",
      pageIcon: Icons.person,
      child: FutureBuilder(
        future: profile,
        builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
          if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: app_theme.white,
                  color: app_theme.blue),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formKey,
              autovalidateMode: submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Text(
                      "Aanpassen",
                      style: app_theme.textTheme.headline6),
                  const SizedBox(height: 10),
                  Text(
                      "Pas hieronder de gegevens aan die u wilt veranderen",
                      textAlign: TextAlign.center,
                      style: app_theme.textTheme.bodyText2!.copyWith(
                          fontSize: 15, color: app_theme.grey)),
                  const SizedBox(height: 25),
                  AccountField(
                    controller: emailController,
                    text: "E-mailadres",
                    hint: "Voer hier uw nieuwe e-mailadres in",
                  ),
                  const SizedBox(height: 15),
                  AccountField(
                      controller: currentPasswordController,
                      text: "Huidig wachtwoord",
                      hint: "Voer hier uw huidige wachtwoord in",
                      private: true
                  ),
                  const SizedBox(height: 15),
                  AccountField(
                      controller: newPasswordController,
                      text: "Nieuw wachtwoord",
                      hint: "Voer hier uw nieuwe wachtwoord in",
                      private: true
                  ),
                  const SizedBox(height: 25),
                  AccountButton(
                      iconData: Icons.check_rounded,
                      text: "Gegevens aanpassen",
                      color: app_theme.blue,
                      onPressed: () => onPressedSubmitBasicsChange()
                  ),
                  const SizedBox(height: 25),
                  AccountButton(
                    iconData: Icons.keyboard_backspace_rounded,
                    text: "Ga terug",
                    color: app_theme.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
