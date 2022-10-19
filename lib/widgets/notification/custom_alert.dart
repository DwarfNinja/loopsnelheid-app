import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class CustomAlert extends AlertDialog {
  CustomAlert({super.key, required String titleText, required String messageText, required String buttonText, required Function()? onPressed, IconData? icon})
      : super(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
    title: Text(titleText, style: app_theme.textTheme.headline6!.copyWith(fontSize: 21)),
    content: Text(
        messageText,
        style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.grey, fontSize: 15)),
    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    actions: [
      TextButton(
        onPressed: onPressed,
        child: Text(
            buttonText,
            textAlign: TextAlign.end,
            style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.blue)),
      ),
    ],
  );
}