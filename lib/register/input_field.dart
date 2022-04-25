import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class InputField extends StatefulWidget {

  const InputField({Key? key, required this.text, required this.hint, required this.private}) : super(key: key);
  final String text;
  final String hint;
  final bool private;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  bool passwordVisible = false;
  bool empty = true;

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
            obscureText: !passwordVisible,
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
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: app_theme.green),
                borderRadius: BorderRadius.all(Radius.circular(12)),
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
              suffixIcon: widget.private ? IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ) : null,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                empty = true;
                return widget.text + " mag niet leeg zijn";
              }
              empty = false;
              return null;
            },
          ),
        ],
      ),
    );
  }
}
