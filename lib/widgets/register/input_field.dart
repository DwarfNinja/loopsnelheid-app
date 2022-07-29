import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final TextEditingController? mustBeSameAsText;
  final String text;
  final String hint;
  final bool private;
  final IconData? icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLength;
  final ValidatorFunction? validatorFunction;

  const InputField({Key? key,
    required this.text,
    required this.hint,
    this.mustBeSameAsText,
    this.controller,
    this.private = false,
    this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.minLength,
    this.validatorFunction
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool textVisible = false;
  bool empty = true;
  bool textTheSame = true;

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
              child: Text(widget.text, style: app_theme.textTheme.headline6!.copyWith(color: app_theme.black)),
            )
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          maxLines: 1,
          obscureText: !widget.private ? false : !textVisible,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: app_theme.grey),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: app_theme.blue),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: !empty && (widget.mustBeSameAsText == null || textTheSame) ? app_theme.green : app_theme.grey),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: app_theme.red),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            errorMaxLines: 2,
            hintText: widget.hint,
            hintStyle: GoogleFonts.montserrat(
                fontSize: 16,
                color: app_theme.grey,
                fontWeight: FontWeight.w300),
            suffixIcon: getIcon(),
          ),
          validator: (String? value) {
            String formattedWidgetText = widget.text;

            if (widget.text.contains(" ")) {
              formattedWidgetText = widget.text.split(" ")[1];
            }

            if (value == null || value.isEmpty) {
              return formattedWidgetText + " mag niet leeg zijn";
            }
            if (widget.minLength != null && value.characters.length < widget.minLength!) {
              return "Het " + formattedWidgetText.toLowerCase() + " moet minimaal " + widget.minLength!.toString() + " characters lang zijn";
            }
            if (widget.mustBeSameAsText != null && !textTheSame) {
              return "De " + formattedWidgetText  + "en moeten hetzelfde zijn";
            }
            if (widget.validatorFunction != null) {
              return widget.validatorFunction!.build(value);
            }
            return null;
          },
          onChanged: (String? value) => setState(() {
            empty = (value == null || value.isEmpty) ? true : false;
            textTheSame = widget.mustBeSameAsText != null && widget.mustBeSameAsText!.text == value;
          }),
        ),
      ],
    );
  }
}

class ValidatorFunction {
  final RegExp? regex;
  final Function? function;
  final String message;

  const ValidatorFunction({this.regex, this.function, required this.message});

  String? build(String value) {
    if (function != null) {
      function!();
    }
    if (regex != null && !regex!.hasMatch(value)) {
      return message;
    }
    return null;
  }
}
