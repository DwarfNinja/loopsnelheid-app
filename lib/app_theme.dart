import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryGradientColor = Color(0xFF264DD2);
const Color secondaryGradientColor = Color(0xFF2F23C1);

const LinearGradient mainLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGradientColor, secondaryGradientColor]
);

final ThemeData themeData = ThemeData(
  primaryColor: const Color(0xFF264DD2),
  primarySwatch: Colors.indigo,
  textTheme: textTheme,
);

final TextTheme textTheme = TextTheme(
  headline2: GoogleFonts.lato(
      fontSize: 60,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline3: GoogleFonts.lato(
      fontSize: 40,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline4: GoogleFonts.lato(
      fontSize: 34,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline5: GoogleFonts.lato(
      fontSize: 28,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline6: GoogleFonts.lato(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  bodyText1: GoogleFonts.lato(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  bodyText2: GoogleFonts.lato(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600),
);