import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class AccountButton extends StatelessWidget {

  final IconData iconData;
  final String text;
  final Color? color;
  final Size? buttonSize;
  final double? iconSize;
  final Function() onPressed;

  const AccountButton({Key? key, required this.iconData, required this.text, this.buttonSize = const Size(300, 50),
    this.iconSize = 33, this.color =  app_theme.blue, required this.onPressed}) : super(key: key);

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
            minimumSize: buttonSize,
            maximumSize: buttonSize,
            backgroundColor: color,
            padding: const EdgeInsets.only(left: 12)
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(iconData,
                color: color!.computeLuminance() > 0.5 ? app_theme.black : app_theme.white,
                size: iconSize),
            const SizedBox(width: 10),
            Text(text, style: app_theme.textTheme.headline6!.copyWith(color: color!.computeLuminance() > 0.5 ? app_theme.black : app_theme.white))
          ],
        ),
      ),
    );
  }
}