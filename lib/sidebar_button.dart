import 'package:flutter/material.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class SideBarButton extends StatefulWidget {

  final IconData iconData;
  final String text;

  const SideBarButton({Key? key, required this.iconData, required this.text}) : super(key: key);

  @override
  State<SideBarButton> createState() => _SideBarButtonState();
}

class _SideBarButtonState extends State<SideBarButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          app_theme.bottomBoxShadow
        ]
      ),
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(275, 60),
            maximumSize: const Size(275, 70),
            backgroundColor: app_theme.blue,
            padding: const EdgeInsets.only(left: 12)
        ),
        onPressed:
            () => Navigator.popUntil(context, ModalRoute.withName('/')),
        child: Row(
          children: [
            Icon(widget.iconData, color: app_theme.white, size: 40),
            const SizedBox(width: 20),
            Text(widget.text, style: app_theme.textTheme.headline6!.copyWith(color: app_theme.white))
          ],
        ),
      ),
    );
  }
}