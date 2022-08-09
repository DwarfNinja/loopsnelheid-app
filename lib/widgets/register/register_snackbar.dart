import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class CustomSnackbar extends SnackBar {
  CustomSnackbar({super.key, required MessageType messageType, required String message, IconData? icon})
      : super(
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 4),
    backgroundColor: messageType == MessageType.success ? app_theme.green : app_theme.red,
    content: Center(
        heightFactor: 1,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                  messageType == MessageType.success ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                  color: app_theme.white, size: 27),
            ),
            Flexible(
              child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: app_theme.textTheme.bodyText2!.copyWith(color: app_theme.white)),
            )
          ],
        )
    ),
  );
}

enum MessageType {
  success,
  error
}





