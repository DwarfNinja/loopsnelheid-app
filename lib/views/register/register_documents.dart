import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;
import 'package:loopsnelheidapp/services/api/register_service.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import '../../models/user.dart';
import '../../services/shared_preferences_service.dart';
import '../../widgets/register/checkbox_line.dart';
import '../../widgets/register/form_button.dart';

class RegisterDocuments extends StatefulWidget {
  const RegisterDocuments({Key? key}) : super(key: key);

  @override
  State<RegisterDocuments> createState() => _RegisterDocumentsState();
}

class _RegisterDocumentsState extends State<RegisterDocuments> {
  final formKey = GlobalKey<FormState>();

  bool termsAndConditions = false;
  bool privacyStatement = false;
  bool olderThanSixteen = false;

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    handleRegisterResponse(response) {
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body!);
        sharedPreferencesService.setInteger("register_id", body['id']);
      } else if (response.statusCode == 400) {
        // Repeat the proces
      }
    }

    assignUserValues(User user) {
      user.termsAndConditions = termsAndConditions;
      user.privacyStatement = privacyStatement;
      user.olderThanSixteen = olderThanSixteen;

      sharedPreferencesService.setObject("registerUser", user);
      RegisterService registerService = RegisterService();
      registerService.registerUser(user).then((response) => handleRegisterResponse(response));
    }

    onPressedNextButton() {
      setState(() => submitted = true);
      if (formKey.currentState!.validate()) {
        sharedPreferencesService.getObject("registerUser").then((user) => (assignUserValues(User.fromJson(user))));
        Navigator.pushNamed(context, "/register_verification");
      }
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
              style: app_theme.textTheme.headline3!.copyWith(color: Colors.white),
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
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Document(text: "Algemene Voorwaarden", documentAsset: 'assets/privacy_verklaring.pdf'),
                          Document(text: "Privacy Verklaring", documentAsset: 'assets/privacy_verklaring.pdf')
                        ],
                      ),
                      const SizedBox(height: 25),
                      CheckboxLine(
                        text: "Ik ga akkoord met de Algemene Voorwaarden",
                        value: termsAndConditions,
                        onChanged: (bool? value) => setState(() => termsAndConditions = !termsAndConditions),
                      ),
                      const SizedBox(height: 15),
                      CheckboxLine(
                        text: "Ik ga akkoord met de Privacy Verklaring",
                        value: privacyStatement,
                        onChanged: (bool? value) => setState(() => privacyStatement = !privacyStatement),
                      ),
                      const SizedBox(height: 15),
                      CheckboxLine(
                        text: "Ik ben ouder dan 16 jaar of heb toestemming \n van een ouder/voogd",
                        value: olderThanSixteen,
                        onChanged: (bool? value) => setState(() => olderThanSixteen = !olderThanSixteen),
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

class Document extends StatelessWidget {
  final String text;
  final String documentAsset;

  const Document({Key? key, required this.text, required this.documentAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (widget) => DocumentDialog(
                    documentAsset: documentAsset)),
            child: Container(
              width: 140,
              height: 180,
              decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/lorem_ipsum_document.png'), fit: BoxFit.cover),
                  boxShadow: const [
                    app_theme.bottomBoxShadow,
                  ],
                  border: Border.all(color: app_theme.grey, width: 2),
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 10),
          Text(text,
              style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 14))
        ],
      ),
    );
  }
}

class DocumentDialog extends StatelessWidget {
  final String documentAsset;

  const DocumentDialog({Key? key, required this.documentAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
      document: PdfDocument.openAsset(documentAsset),
    );

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 500,
        child: PdfView(
          controller: pdfController,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
