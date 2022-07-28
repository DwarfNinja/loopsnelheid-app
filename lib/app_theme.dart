import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);
const Color grey = Color(0xFF787878);
const Color lightBlue = Color(0xFF2BBFFE);
const Color blue = Color(0xFF1D58EF);
const Color darkBlue = Color(0xFF2215C2);
const Color red = Color(0xFFD81E4B);
const Color yellowOrange = Color(0xFFFFBE16);
const Color green = Color(0xFF8CE137);
const Color lightGreen = Color(0xFFC8E70F);


const LinearGradient mainLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blue, darkBlue]
);

const LinearGradient greenLightLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGreen, green]
);

const LinearGradient yellowRedLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [yellowOrange, red]
);

 const BoxShadow topBoxShadow = BoxShadow(
    color: Color(0x40000000),
    offset: Offset(0, 8),
    blurRadius: 4
);

const BoxShadow bottomBoxShadow = BoxShadow(
    color: Color(0x40000000),
    offset: Offset(0, 8),
    blurRadius: 4
);


final ThemeData themeData = ThemeData(
  primaryColor: blue,
  primarySwatch: Colors.indigo,
  textTheme: textTheme,
);

final TextTheme textTheme = TextTheme(
  headline2: GoogleFonts.montserrat(
      fontSize: 60,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline3: GoogleFonts.montserrat(
      fontSize: 38,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline4: GoogleFonts.montserrat(
      fontSize: 34,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline5: GoogleFonts.montserrat(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  headline6: GoogleFonts.montserrat(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  bodyText1: GoogleFonts.montserrat(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w600),
  bodyText2: GoogleFonts.montserrat(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600),
);