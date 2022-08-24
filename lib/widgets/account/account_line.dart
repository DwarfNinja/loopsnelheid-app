import 'package:flutter/material.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class AccountLine extends StatefulWidget {

  final String label;
  final String text;
  final Color? textColor;

  const AccountLine({Key? key, required this.label, required this.text, this.textColor = app_theme.black}) : super(key: key);

  @override
  State<AccountLine> createState() => AccountLineState();
}

class AccountLineState extends State<AccountLine> {

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label,
              style: app_theme.textTheme.bodyText1!.copyWith(
                  color: widget.textColor)
          ),
          Text(widget.text,
              style: app_theme.textTheme.bodyText1!.copyWith(
                  color: widget.textColor)
          )
        ]
    );
  }
}


