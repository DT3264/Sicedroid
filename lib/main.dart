import 'package:flutter/material.dart';
import 'Utils/theme.dart';
import 'Routes/routes.dart';
import 'package:sicedroid/Pages/main_page.dart';
import 'package:sicedroid/Pages/carga_page.dart';
import 'package:sicedroid/Pages/login_page.dart';
import 'package:sicedroid/Pages/kardex_page.dart';
import 'package:sicedroid/Pages/finales_page.dart';
import 'package:sicedroid/Pages/parciales_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => LoginPage(),
        Routes.main: (context) => MainPage(),
        Routes.parciales: (context)=>ParcialesPage(),
        Routes.finales: (context)=>FinalesPage(),
        Routes.carga: (context)=>CargaPage(),
        Routes.kardex: (context)=>KardexPage(),
      },
      title: 'Sicedroid',
      theme:
          ThemeData(primarySwatch: primaryColor, accentColor: secondaryColor),
    );
  }
}
