import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loopsnelheidapp/widgets/register/input_field.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class AccountField extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final String hint;
  final bool private;
  final IconData? icon;
  final TextInputType? keyboardType;
  final ValidatorFunction? validatorFunction;

  const AccountField({Key? key,
    required this.text,
    required this.hint,
    this.controller,
    this.private = false,
    this.icon,
    this.keyboardType,
    this.validatorFunction,
  }) : super(key: key);

  @override
  State<AccountField> createState() => _AccountFieldState();
}

class _AccountFieldState extends State<AccountField> {
  bool textVisible = false;
  bool empty = true;

  Widget? getIcon() {
    if (widget.private) {
      return IconButton(
        icon: Icon(
          textVisible ? Icons.visibility : Icons.visibility_off,
          color: app_theme.grey,
        ),
        onPressed: () {
          setState(() {
            textVisible = !textVisible;
          });
        },
      );
    }
    else if (widget.icon != null) {
      return Icon(
          widget.icon,
          color: app_theme.grey);
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  widget.text,
                  style: app_theme.textTheme.bodyText1!.copyWith(color: app_theme.black)),
            )
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          maxLines: 1,
          obscureText: !widget.private ? false : !textVisible,
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0.75),
            contentPadding: const EdgeInsets.all(10),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: app_theme.grey),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: app_theme.blue),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: !empty ? app_theme.green : app_theme.grey),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: app_theme.red),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            errorMaxLines: 2,
            hintText: widget.hint,
            hintStyle: GoogleFonts.montserrat(
                fontSize: 14,
                color: app_theme.grey,
                fontWeight: FontWeight.w400),
            suffixIcon: getIcon(),
          ),
          validator: (String? value) {

            if (value != null && widget.validatorFunction != null) {
              return widget.validatorFunction!.build(value);
            }
            return null;
          },
          onChanged: (String? value) => setState(() {
            empty = (value == null || value.isEmpty) ? true : false;
          }),
        ),
      ],
    );
  }
}