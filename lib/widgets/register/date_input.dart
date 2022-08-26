import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:loopsnelheidapp/app_theme.dart' as app_theme;

class DateInput extends StatefulWidget {
  final TextEditingController controller;
  final TextStyle? headerStyle;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;

  const DateInput({
    Key? key,
    required this.controller,
    this.headerStyle,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.hintStyle
  }) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {

  bool empty = true;
  DateTime? pickedDate;

  @override
  void initState() {
    widget.controller.text = "";
    widget.controller.addListener(onDateInputControllerChanged);
    super.initState();
  }

  void onDateInputControllerChanged() {
    setState(() {
      empty = (widget.controller.text == "") ? true : false;
    });
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
                  "Geboortedatum",
                  style: widget.headerStyle ?? app_theme.textTheme.headline6!.copyWith(color: app_theme.black)),
            )
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          maxLines: 1,
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0.75),
            contentPadding: widget.contentPadding,
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
            hintText: "xx-xx-xxxx",
            hintStyle: widget.hintStyle ?? GoogleFonts.montserrat(
                fontSize: 16,
                color: app_theme.grey,
                fontWeight: FontWeight.w300),
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: app_theme.blue,
                      onPrimary: app_theme.white,
                      onSurface: app_theme.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        primary: app_theme.black,
                      ),
                    ),
                  ),
                  child: child!,
                ),
                context: context, initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            );
            if(pickedDate != null ){
              this.pickedDate = pickedDate;

              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
              setState(() {
                widget.controller.text = formattedDate;
              });
            }
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          validator: (String? value) {
            if (widget.controller.text.isEmpty) {
              return "De geboortedatum mag niet leeg zijn";
            }

            if (DateTime.now().year - pickedDate!.year < 18) {
              return "De gebruiker moet 18 jaar of ouder zijn";
            }

            return null;
          },
        ),
      ],
    );
  }
}