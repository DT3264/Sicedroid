import 'dart:ui';

import 'package:flutter/material.dart';

Color getColorByCalif(int calif) {
  if (calif >= 85) return Colors.green;
  if (calif >= 70) return Colors.orange[400];
  return Colors.red;
}

Map<int, Color> primarySwatch = {
  50: Color.fromRGBO(76, 175, 80, .1),
  100: Color.fromRGBO(76, 175, 80, .2),
  200: Color.fromRGBO(76, 175, 80, .3),
  300: Color.fromRGBO(76, 175, 80, .4),
  400: Color.fromRGBO(76, 175, 80, .5),
  500: Color.fromRGBO(76, 175, 80, .6),
  600: Color.fromRGBO(76, 175, 80, .7),
  700: Color.fromRGBO(76, 175, 80, .8),
  800: Color.fromRGBO(76, 175, 80, .9),
  900: Color.fromRGBO(76, 175, 80, 1)
};

Color green = Colors.amber;

Map<int, Color> secondarySwatch = {
  50: Color.fromRGBO(255, 193, 7, .1),
  100: Color.fromRGBO(255, 193, 7, .2),
  200: Color.fromRGBO(255, 193, 7, .3),
  300: Color.fromRGBO(255, 193, 7, .4),
  400: Color.fromRGBO(255, 193, 7, .5),
  500: Color.fromRGBO(255, 193, 7, .6),
  600: Color.fromRGBO(255, 193, 7, .7),
  700: Color.fromRGBO(255, 193, 7, .8),
  800: Color.fromRGBO(255, 193, 7, .9),
  900: Color.fromRGBO(255, 193, 7, 1)
};

MaterialColor primaryColor = MaterialColor(0xFF4CAF50, primarySwatch);
MaterialColor secondaryColor = MaterialColor(0xFFFFC107, secondarySwatch);
