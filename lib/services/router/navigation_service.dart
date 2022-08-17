import 'package:flutter/widgets.dart';

class NavigationService {
  static void executeRoute(BuildContext context, String name)
  {
    Navigator.pushReplacementNamed(context, name);
  }
}