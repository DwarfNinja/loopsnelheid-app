import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationService {
  static void executeRoute(BuildContext context, String name)
  {
    if (ModalRoute.of(context)?.settings.name == name) {
      Navigator.pop(context);
    }
    else {
      Navigator.pushReplacementNamed(context, name);
    }

  }
}