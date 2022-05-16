import 'package:flutter/material.dart';

class MyTheme {
  static const fontName = 'Cairo';
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: nearlyBlack,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: nearlyBlack,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontSize: 16,
    letterSpacing: -0.05,
    color: nearlyBlack,
  );

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    bodyText1: body1,
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: fontName,
    textTheme: textTheme,
    primarySwatch: Colors.blue,
  );
}
