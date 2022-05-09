import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class InputField extends StatefulWidget {

  final String text;
  final String hint;
  final bool private;
  final IconData? icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InputField({Key? key,
    required this.text,
    required this.hint,
    this.private = false,
    this.icon,
    this.keyboardType,
    this.inputFormatters
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  bool passwordVisible = false;
  bool empty = true;

  Widget? getIcon() {
    if (widget.private) {
      return IconButton(
        icon: Icon(
          passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: app_theme.grey,
        ),
        onPressed: () {
          setState(() {
            passwordVisible = !passwordVisible;
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
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
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
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            maxLines: 1,
            obscureText: !widget.private ? false : !passwordVisible,
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
                borderSide: BorderSide(width: 2, color: empty ? app_theme.grey : app_theme.green),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: app_theme.red),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: widget.hint,
              hintStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: app_theme.grey,
                  fontWeight: FontWeight.w300),
              suffixIcon: getIcon(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return widget.text + " mag niet leeg zijn";
              }
              return null;
            },
            onChanged: (String? value) => setState(() {
              if (value == null || value.isEmpty) {
                empty = true;
              }
              empty = false;
            }),
          ),
        ],
      ),
    );
  }
}
