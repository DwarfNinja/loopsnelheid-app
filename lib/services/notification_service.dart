import 'package:flutter/material.dart';

class NotificationService {

  static void showAlert(BuildContext context, AlertDialog alertDialog, {bool dismissable = true}) {
    showDialog(
      barrierDismissible: dismissable,
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
