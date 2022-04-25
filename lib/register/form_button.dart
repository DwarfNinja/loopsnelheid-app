import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class FormButton extends StatelessWidget {

  final String text;
  final Function() onPressed;

  const FormButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

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
            minimumSize: const Size(450, 60),
            backgroundColor: app_theme.blue,
        ),
        onPressed: onPressed,
        child: Text(text, style: app_theme.textTheme.headline6!.copyWith(color: app_theme.white))
      ),
    );
  }
}