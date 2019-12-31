import 'package:flutter/material.dart';
import 'package:sicedroid/Routes/routes.dart';

//Wrapper para las pages, 
//para que vuelvan a la pantalla principal una vez presionado atrás
//independientemente de donde se encuentren.
class BackButtonHandler extends StatelessWidget {
  final Widget child;
  BackButtonHandler(BuildContext context,  {this.child});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () {
        Navigator.pushReplacementNamed(context, Routes.main);
        return;
      },
    );
  }
}
