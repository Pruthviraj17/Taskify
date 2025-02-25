import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.blue),
    ),
  ),
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xffffea00),
    primary: Color(0xffffdd00),
    secondary: Color(0xffffd000),
    tertiary: Color(0xffffc300),
  ),
);

ThemeData darkTheme = ThemeData(
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white),
    ),
  ),
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xff003356),
    primary: Color(0xff002137),
    secondary: Color(0xff001a2c),
    tertiary: Color(0xff001523),
  ),
);
