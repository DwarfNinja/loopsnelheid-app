import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/widgets/info_base.dart';
import 'package:loopsnelheidapp/widgets/account/account_field.dart';
import 'package:loopsnelheidapp/widgets/account/account_button.dart';
import 'package:loopsnelheidapp/widgets/notification/custom_snackbar.dart';
import 'package:loopsnelheidapp/widgets/register/date_input.dart';
import 'package:loopsnelheidapp/widgets/gender_toggle.dart';

import 'package:loopsnelheidapp/services/api/profile_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';
import 'package:loopsnelheidapp/services/notification_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class EditDetails extends StatefulWidget {

  const EditDetails({Key? key})
      : super(key: key);

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final formKey = GlobalKey<FormState>();

  final dateOfBirthController = TextEditingController();
  final sexController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

  bool isFemale = false;
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
    else {
      Future<Profile> response = ProfileService.getAccount();
      response.then((value) => {
        setAccountInFields(value)
      });
      return response;
    }
  }

  setAccountInFields(Profile profile) {
    setState(() {
      isFemale = profile.sex == "FEMALE";
      dateOfBirthController.text = profile.dateOfBirth;
      heightController.text = profile.height.toString();
      weightController.text = profile.weight.toString();
    });
  }

  void onPressedSubmitBasicsChange() {
    final format = DateFormat("dd-MM-yyyy");
    DateTime gettingDate = format.parse(dateOfBirthController.text);
    String formattedDate = DateFormat('yyyy-MM-dd').format(gettingDate);

    String formattedSex = isFemale ? "FEMALE" : "MALE";

    if (formKey.currentState!.validate()) {
      profile?.then((value) => {
        ProfileService.changeDetails(formattedSex, formattedDate, int.parse(heightController.text), int.parse(weightController.text), value.isResearchCandidate)
          .then((response) => handleRegisterResponse(response))
      });
    }
  }

  handleRegisterResponse(response) {
    if (response == 200) {
      NotificationService.showSnackBar(context, CustomSnackbar(messageType: MessageType.success, message: "Success! U gegevens zijn aangepast!"));
    } else if (response == 400) {
      NotificationService.showSnackBar(context, CustomSnackbar(messageType: MessageType.error, message: "Fout! Er is iets misgegaan met het aanpassen van u gegevens!"));
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
                  GenderToggle(
                      headerStyle: app_theme.textTheme.bodyText1!.copyWith(
                          color: app_theme.black),
                      switchSize: const Size(105, 35),
                      toggleSize: 30,
                      value: isFemale,
                      onToggle: (val) {
                        setState(() {
                          isFemale = val;
                        });
                      }),
                  const SizedBox(height: 15),
                  DateInput(
                    controller: dateOfBirthController,
                    headerStyle: app_theme.textTheme.bodyText1!.copyWith(
                        color: app_theme.black),
                    contentPadding: const EdgeInsets.all(10),
                    hintStyle: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: app_theme.grey,
                        fontWeight: FontWeight.w400),),
                  const SizedBox(height: 15),
                  AccountField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    text: "Lengte",
                    hint: "Voer hier uw lengte in",
                  ),
                  const SizedBox(height: 15),
                  AccountField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    text: "Gewicht",
                    hint: "Voer hier uw gewicht in",
                  ),
                  const SizedBox(height: 25),
                  AccountButton(
                    iconData: Icons.check_rounded,
                    text: "Gegevens aanpassen",
                    color: app_theme.blue,
                    onPressed: () => onPressedSubmitBasicsChange(),
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
