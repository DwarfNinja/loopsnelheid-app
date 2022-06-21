import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class SideBarButton extends StatelessWidget {

  final IconData iconData;
  final String text;
  final Function() onPressed;

  const SideBarButton({Key? key, required this.iconData, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            app_theme.bottomBoxShadow
          ]
      ),
      child: ElevatedButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(275, 60),
            maximumSize: const Size(275, 70),
            backgroundColor: app_theme.blue,
            padding: const EdgeInsets.only(left: 12)
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(iconData, color: app_theme.white, size: 40),
            const SizedBox(width: 10),
            Text(text, style: app_theme.textTheme.headline6!.copyWith(color: app_theme.white))
          ],
        ),
      ),
    );
  }
}