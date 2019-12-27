import 'package:flutter/material.dart';
import 'package:sicedroid/Pages/login_page.dart';
import 'Utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sicedroid',
      theme: ThemeData(
        primarySwatch: primaryColor,
        accentColor: secondaryColor
      ),
      home: LoginPage(),
    );
  }
}