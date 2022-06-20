import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/models/verify_token.dart';
import 'package:loopsnelheidapp/services/api/register_service.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

import 'package:loopsnelheidapp/widgets/register/form_button.dart';

class RegisterVerification extends StatefulWidget {

  const RegisterVerification({Key? key})
      : super(key: key);

  @override
  _RegisterVerificationState createState() =>
      _RegisterVerificationState();
}

class _RegisterVerificationState extends State<RegisterVerification> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    activationIsSuccess() {
      setState(() => hasError = false);
      Navigator.pushNamed(context, "/login");
    }

    activationIsIncorrect() {
      errorController!.add(ErrorAnimationType.shake);
      setState(() => hasError = true);
    }

    activateAccount() {
      formKey.currentState!.validate();

      VerifyToken verifyToken = VerifyToken(1, currentText);
      RegisterService registerService = RegisterService();
      registerService.verifyEmailByDigitalCode(verifyToken).then((success) => {
        if (!success) {
          activationIsIncorrect()
        } else {
          activationIsSuccess()
        }
      });
    }

    return Scaffold(
      backgroundColor: app_theme.blue,
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
              style:
              app_theme.textTheme.headline3!.copyWith(color: Colors.white),
            ),
            const Icon(
              Icons.directions_walk,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 10),
            Container(
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
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Bevestig u e-mailadres',
                    style: app_theme.textTheme.headline5!
                        .copyWith(color: app_theme.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                        "Voer alstublieft uw 6-cijferige verificatie code in die u via de mail heeft ontvangen.",
                        style: app_theme.textTheme.bodyText2!
                            .copyWith(color: app_theme.grey, fontSize: 14),
                        textAlign: TextAlign.justify),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: const TextStyle(
                            color: app_theme.green,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (value) {
                            if (value!.length == 6) {
                              hasError = false;
                            }
                            return null;
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            borderWidth: 2,
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeColor: app_theme.green,
                            activeFillColor: app_theme.white,
                            selectedColor: app_theme.blue,
                            selectedFillColor: app_theme.white,
                            inactiveColor: app_theme.grey,
                            inactiveFillColor: app_theme.white,
                            errorBorderColor: app_theme.red,
                          ),
                          cursorColor: app_theme.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                        )),
                  ),
                  const SizedBox(height: 10),
                  hasError ? Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                        color: app_theme.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          app_theme.bottomBoxShadow
                        ]
                    ),
                    child: Center(
                      child: Text(
                        hasError ? "Incorrecte Code" : "",
                        style: app_theme.textTheme.bodyText2!
                            .copyWith(color: app_theme.white, fontSize: 15),
                      ),
                    ),
                  ) : const SizedBox(width: 150, height: 30),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        FormButton(
                          text: "Verifieer",
                          color: app_theme.blue,
                          onPressed: () {
                            activateAccount();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormButton(
                            text: "Ga Terug",
                            color: app_theme.white,
                            onPressed: () => null
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}