import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class CustomSnackbar extends SnackBar {
  CustomSnackbar({super.key, required MessageType messageType, required String message, IconData? icon})
      : super(
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 4),
    backgroundColor: getBackgroundColor(messageType),
    content: Center(
        heightFactor: 1,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                  getIcon(messageType),
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

Color getBackgroundColor(messageType) {
    switch(messageType) {
      case MessageType.success: {
        return app_theme.green;
      }
      case MessageType.error: {
        return app_theme.red;
      }
      case MessageType.info: {
        return app_theme.blue;
      }
      default: {
        return app_theme.blue;
      }
    }
}

IconData getIcon(messageType) {
  switch(messageType) {
    case MessageType.success: {
      return Icons.check_circle_outline_rounded;
    }
    case MessageType.error: {
      return Icons.error_outline_rounded;
    }
    case MessageType.info: {
      return Icons.info_outline_rounded;
    }
    default: {
      return Icons.info_outline_rounded;
    }
  }
}

enum MessageType {
  success,
  error,
  info
}





