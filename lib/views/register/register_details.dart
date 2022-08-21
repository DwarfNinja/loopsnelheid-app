import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import 'package:loopsnelheidapp/models/user.dart';

import 'package:loopsnelheidapp/widgets/register/date_input.dart';
import 'package:loopsnelheidapp/widgets/register/form_button.dart';
import 'package:loopsnelheidapp/widgets/register/input_field.dart';

import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/widgets/register/register_base.dart';

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
  final heightController = TextEditingController();
  
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
      user.height = int.parse(heightController.text);
      user.dateOfBirth = formattedDate;
      user.sex = isFemale ? "FEMALE" : "MALE";
      sharedPreferencesService.setObject("registerUser", user);
    }

    onPressedNextButton() {
      setState(() => submitted = true);
      if (formKey.currentState!.validate()) {
        sharedPreferencesService.getObject("registerUser").then((user) => (assignUserValues(User.fromJson(user))));
        Navigator.pushNamed(context, "/register_documents");
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
              "Vul uw details hieronder in",
              textAlign: TextAlign.center,
              style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 15, color: app_theme.grey)),
          const SizedBox(height: 20),
          GenderToggle(
              value: isFemale,
              onToggle: (val) {
                setState(() {
                  isFemale = val;
                });
              }),
          const SizedBox(height: 20),
          DateInput(controller: dateOfBirthController),
          const SizedBox(height: 20),
          InputField(
              controller: weightController,
              text: "Gewicht",
              hint: "Voer uw gewicht in kilogram",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'^\d{0,3}'), allow: true)
              ]
          ),
          const SizedBox(height: 20),
          InputField(
              controller: heightController,
              text: "Lengte",
              hint: "Voer uw lengte in centimeter",
              article: "De",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'^\d{0,3}'), allow: true)
              ]
          )
        ]
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