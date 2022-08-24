import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'form_button.dart';

class RegisterBase extends StatefulWidget {

  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  final bool submitted;
  final FormButton firstButton;
  final FormButton secondButton;

  const RegisterBase({Key? key, this.children = const [], required this.formKey, required this.submitted, required this.firstButton, required this.secondButton}) : super(key: key);

  @override
  State<RegisterBase> createState() => RegisterBaseState();
}

class RegisterBaseState<T extends RegisterBase> extends State<T> {

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    return Scaffold(
        backgroundColor: app_theme.blue,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height),
            child: Container(
                decoration: const BoxDecoration(
                  gradient: app_theme.mainLinearGradient,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        "Loopsnelheid",
                        style: app_theme.textTheme.headline3!.copyWith(color: Colors.white),
                      ),
                      const Icon(
                        Icons.directions_walk,
                        color: Colors.white,
                        size: 55,
                      ),
                      const SizedBox(height: 10),
                      Container(
                          width: double.infinity,
                          height: 700,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                                bottom: Radius.zero),
                            boxShadow: [
                              app_theme.bottomBoxShadow,
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
                              child: Form(
                                  key: widget.formKey,
                                  autovalidateMode: widget.submitted
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: widget.children + [
                                      const SizedBox(height: 30),
                                      widget.firstButton,
                                      const SizedBox(height: 15),
                                      widget.secondButton],
                                  )
                              )
                          )
                      )
                    ]
                )
            ),
          ),
        )
    );
  }
}
