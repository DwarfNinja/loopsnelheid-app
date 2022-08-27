import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/services/api/profile_service.dart';

import 'package:loopsnelheidapp/models/profile.dart';

import 'package:loopsnelheidapp/widgets/account/account_button.dart';
import 'package:loopsnelheidapp/widgets/account/account_line.dart';
import 'package:loopsnelheidapp/widgets/info_base.dart';

import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class Account extends StatefulWidget {

  const Account({Key? key})
      : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

  bool requestedPasswordChange = false;

  Profile profile = Profile(0, "laden...", "laden...", "laden...", false, false, 0, 0, ["laden.."]);

  void getAccount() async {
    await sharedPreferencesService.getSharedPreferenceInstance();

    await ProfileService.getAccount().then((value) => {
      setState(() {
        profile = value;
      }),
      sharedPreferencesService.setObject("profile", profile)
    });
  }

  onPressedSubmitPasswordChange() {
    if (formKey.currentState!.validate()) {
      ProfileService.changePassword(currentPasswordController.text, newPasswordController.text);
    }
  }

  @override
  void initState() {
    super.initState();

    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    return InfoBase(
      pageName: "Account",
      pageIcon: Icons.person,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Column(
              children: [
                AccountLine(label: "Email", text: profile.email),
                const SizedBox(height: 20),
                const AccountLine(label: "Wachtwoord", text: "●●●●●●●●"),
                const SizedBox(height: 20),
                AccountLine(label: "Geboortedatum", text: profile.dateOfBirth),
                const SizedBox(height: 20),
                AccountLine(label: "Geslacht", text: profile.sex == "MALE" ? "MAN" : "VROUW"),
                const SizedBox(height: 20),
                AccountLine(label: "Lengte", text: profile.height.toString()),
                const SizedBox(height: 20),
                AccountLine(label: "Gewicht", text: profile.weight.toString()),
              ],
            ),
          ),
          const SizedBox(height: 50),
          profile.hasOpenDeleteRequest ? AccountButton(
              iconData: Icons.cancel_outlined,
              text: "Verwijderen annuleren",
              color: app_theme.red,
              onPressed: () async {
                await ProfileService.cancelAccountDeletion().then((value) => {
                  getAccount()
                });
              }) : AccountButton(
            iconData: Icons.delete_rounded,
            text: "Account verwijderen",
            color: app_theme.red,
            onPressed: () async {
              await ProfileService.deleteAccount().then((value) => {
                getAccount()
              });
            },
          ),
          const SizedBox(height: 20),
          AccountButton(
            iconData: Icons.lock_person_rounded,
            text: "Login aanpassen",
            color: app_theme.blue,
            onPressed: () => Navigator.pushNamed(context, "/edit_basics"),
          ),
          const SizedBox(height: 20),
          AccountButton(
            iconData: Icons.edit_rounded,
            text: "Details aanpassen",
            color: app_theme.blue,
            onPressed: () => Navigator.pushNamed(context, "/edit_details"),
          ),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final String hint;
  final bool private;
  final IconData? icon;

  const PasswordField({Key? key,
    required this.text,
    required this.hint,
    this.controller,
    this.private = false,
    this.icon,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool textVisible = false;
  bool empty = true;

  Widget? getIcon() {
    if (widget.private) {
      return IconButton(
        icon: Icon(
          textVisible ? Icons.visibility : Icons.visibility_off,
          color: app_theme.grey,
        ),
        onPressed: () {
          setState(() {
            textVisible = !textVisible;
          });
        },
      );
    }
    else if (widget.icon != null) {
      return Icon(
          widget.icon,
          color: app_theme.grey);
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      maxLines: 1,
      obscureText: !widget.private ? false : !textVisible,
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0.75),
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 45),
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: app_theme.grey),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: app_theme.blue),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: !empty ? app_theme.green : app_theme.grey),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: app_theme.red),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorMaxLines: 2,
        hintText: widget.hint,
        hintStyle: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.grey, fontWeight: FontWeight.w300),
        suffixIcon: getIcon(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Wachtwoord mag niet leeg zijn";
        }
        return null;
      },
      onChanged: (String? value) => setState(() {
        empty = (value == null || value.isEmpty) ? true : false;
      }),
    );
  }
}
