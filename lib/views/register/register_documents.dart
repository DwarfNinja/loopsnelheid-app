import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/widgets/register/register_base.dart';

import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:loopsnelheidapp/models/user.dart';

import 'package:loopsnelheidapp/widgets/register/checkbox_line.dart';
import 'package:loopsnelheidapp/widgets/register/form_button.dart';

import 'package:loopsnelheidapp/services/api/register_service.dart';
import 'package:loopsnelheidapp/services/shared_preferences_service.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

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
  bool isResearchCandidate = false;

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    sharedPreferencesService.getSharedPreferenceInstance();

    GlobalKey<CheckboxLineState> termsAndConditionsKey = GlobalKey();
    GlobalKey<CheckboxLineState> privacyStatementKey = GlobalKey();
    GlobalKey<CheckboxLineState> olderThanSixteenKey = GlobalKey();
    GlobalKey<CheckboxLineState> isResearchCandidateKey = GlobalKey();

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
      user.isResearchCandidate = isResearchCandidate;

      sharedPreferencesService.setObject("registerUser", user);
      RegisterService registerService = RegisterService();
      registerService.registerUser(user).then((response) => handleRegisterResponse(response));
    }

    bool agreedToAllField() {
      return (termsAndConditions && privacyStatement && olderThanSixteen && isResearchCandidate);
    }

    onPressedNextButton() {
      setState(() => submitted = true);
      if (agreedToAllField() && formKey.currentState!.validate()) {
        sharedPreferencesService.getObject("registerUser").then((user) => (assignUserValues(User.fromJson(user))));
        Navigator.pushNamed(context, "/register_verification");
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
              "Lees en accepteer de voorwaarden hieronder",
              style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 15, color: app_theme.grey)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Document(text: "Algemene Voorwaarden", documentAsset: 'assets/privacy_verklaring.pdf'),
              Document(text: "Privacy Verklaring", documentAsset: 'assets/privacy_verklaring.pdf')
            ],
          ),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              children: [
                CheckboxLine(
                    key: termsAndConditionsKey,
                    text: "Ik ga akkoord met de Algemene Voorwaarden",
                    value: termsAndConditions,
                    onChanged: (bool? value) => setState(() => termsAndConditions = !termsAndConditions),
                    submitted: submitted
                ),
                const SizedBox(height: 15),
                CheckboxLine(
                    key: privacyStatementKey,
                    text: "Ik ga akkoord met de Privacy Verklaring",
                    value: privacyStatement,
                    onChanged: (bool? value) => setState(() => privacyStatement = !privacyStatement),
                    submitted: submitted
                ),
                const SizedBox(height: 15),
                CheckboxLine(
                    key: isResearchCandidateKey,
                    text: "Mijn gegevens mogen gebruikt worden \n voor onderzoeksdoeleinden",
                    value: isResearchCandidate,
                    onChanged: (bool? value) => setState(() => isResearchCandidate = !isResearchCandidate),
                    submitted: submitted
                )
              ],
            ),
          ),
        ]
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (widget) => DocumentDialog(
                  documentAsset: documentAsset)),
          child: Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 140, minHeight: 140, maxHeight: 170),
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
        Text(
            text,
            textAlign: TextAlign.center,
            style: app_theme.textTheme.bodyText2!.copyWith(fontSize: 14)
        )
      ]
    );
  }
}

class DocumentDialog extends StatelessWidget {
  final String documentAsset;

  const DocumentDialog({Key? key, required this.documentAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
      document: PdfDocument.openAsset(documentAsset)
    );
    return Dialog(
      child: SizedBox(
        width: 600,
        height: 600,
        child: PdfView(
          controller: pdfController,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
