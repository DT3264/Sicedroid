import 'package:flutter/material.dart';
import 'package:sicedroid/Pages/login_page.dart';
import 'package:sicedroid/Pages/main_page.dart';
import 'package:sicedroid/Pages/parciales_page.dart';
import 'Routes/routes.dart';
import 'Utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => LoginPage(),
        Routes.main: (context) => MainPage(),
        Routes.parciales: (context)=>ParcialesPage()
      },
      title: 'Sicedroid',
      theme:
          ThemeData(primarySwatch: primaryColor, accentColor: secondaryColor),
      home: LoginPage(),
    );
  }
}
