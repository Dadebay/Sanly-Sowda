import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './constants.dart';

MaterialColor appColor = const MaterialColor(
  0xFF0075A4,
  <int, Color>{
    50: Color(0xFFFF7643),
    100: Color(0xFFFF7643),
    200: Color(0xFFFF7643),
    300: Color(0xFFFF7643),
    400: Color(0xFFFF7643),
    500: Color(0xFFFF7643),
    600: Color(0xFFFF7643),
    700: Color(0xFFFF7643),
    800: Color(0xFFFF7643),
    900: Color(0xFFFF7643),
  },
);

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
    textTheme: textTheme(),
    primarySwatch: appColor,
    brightness: Brightness.light,
    fontFamily: gilroyRegular,
    colorSchemeSeed: kPrimaryColor,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: gilroySemiBold,
        fontSize: 20,
      ),
      elevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent.withOpacity(0),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      primary: kPrimaryColor,
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 30,
      vertical: 10,
    ),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: kTextColor),
    bodyMedium: TextStyle(color: kTextColor),
  );
}
