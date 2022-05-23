import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:loopsnelheidapp/register/form_button.dart';
import 'package:loopsnelheidapp/register/input_field.dart';

import 'package:loopsnelheidapp/sidebar.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import '../models/user.dart';
import '../services/shared_preferences_service.dart';
import 'date_input.dart';

class RegisterDetails extends StatefulWidget {

  const RegisterDetails({Key? key})
      : super(key: key);

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final formKey = GlobalKey<FormState>();
  
  final dateOfBirthController = TextEditingController();
  final weightController = TextEditingController();
  
  bool isFemale = false;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    assignUserValues(User user) {
      final format = DateFormat("dd-MM-yyyy");
      DateTime gettingDate = format.parse(dateOfBirthController.text);
      String formattedDate = DateFormat('yyyy-MM-dd').format(gettingDate);

      user.weight = int.parse(weightController.text);
      user.dateOfBirth = formattedDate;
      user.sex = isFemale ? "FEMALE" : "MALE";
      sharedPreferencesService.setObject("registerUser", user);
    }

    onPressedNextButton() {
      sharedPreferencesService.getObject("registerUser").then((user) => (assignUserValues(User.fromJson(user))));
      Navigator.pushNamed(context, "/register_documents");
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
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      GenderToggle(
                        value: isFemale,
                        onToggle: (val) {
                          setState(() {
                            isFemale = val;
                          });
                        }),
                      const SizedBox(height: 25),
                      DateInput(controller: dateOfBirthController),
                      const SizedBox(height: 20),
                      InputField(
                        controller: weightController,
                        text: "Gewicht",
                        hint: "Voer uw gewicht in kilogram",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'), allow: true)
                        ],
                      ),
                      const SizedBox(height: 25),
                      FormButton(
                          text: "Volgende",
                          color: app_theme.blue,
                          onPressed: () => onPressedNextButton()),
                      const SizedBox(height: 15),
                      FormButton(
                          text: "Ga Terug",
                          color: app_theme.white,
                          onPressed: () => Navigator.pop(context))
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

class GenderToggle extends StatefulWidget {
  final Function(bool) onToggle;
  final bool value;

  const GenderToggle({Key? key, required this.onToggle, required this.value}) : super(key: key);

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
                "Geslacht",
                style: app_theme.textTheme.headline6!.copyWith(color: app_theme.black)
            ),
          ),
        ),
        const SizedBox(height: 17),
        FlutterSwitch(
          width: 120,
          height: 40,
          valueFontSize: 18,
          toggleSize: 35,
          value: widget.value,
          activeText: "Vrouw",
          inactiveText: "Man",
          activeIcon: const Icon(Icons.female),
          inactiveIcon: const Icon(Icons.male),
          activeColor: app_theme.red,
          inactiveColor: app_theme.blue,
          showOnOff: true,
          onToggle: widget.onToggle,
        ),
      ],
    );
  }
}