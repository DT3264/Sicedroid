import 'package:flutter/material.dart';
import 'package:sicedroid/Models/alumno_academico.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Utils/theme.dart';
import 'package:sicedroid/Routes/routes.dart';

class MainPageDrawer extends StatelessWidget {
  final AlumnoAcademico alumno;
  final String page;
  MainPageDrawer({BuildContext context, this.page, this.alumno});
  @override
  Widget build(BuildContext context, {AlumnoAcademico alumno}) {
    return Drawer(
        child: FutureBuilder(
      future: Singleton.get().getAlumno(),
      builder: (buildContext, snapshot) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(snapshot.data),
            _createDrawerItem(
                iconPath: 'Assets/datos_academicos.png',
                text: 'Datos Académicos',
                page: Routes.main,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.main);
                }),
            _createDrawerItem(
                iconPath: 'Assets/carga_academica.png',
                text: 'Carga Académica',
                page: Routes.main, //TODO: Replace
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.main);
                }),
            _createDrawerItem(
                iconPath: 'Assets/calificaciones_parciales.png',
                text: 'Calificaciones Parciales',
                page: Routes.main, //TODO: To replace
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.main);
                }),
            _createDrawerItem(
                iconPath: 'Assets/calificaciones_finales.png',
                text: 'Calificaiones Finales',
                page: Routes.main, //TODO: Replace
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.main);
                }),
            _createDrawerItem(
                iconPath: 'Assets/kardex.png',
                text: 'Kardex',
                page: Routes.main, //TODO: Replace
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.main);
                }),
            _createDrawerItem(
                iconPath: 'Assets/salir.png',
                text: 'Salir',
                page: Routes.login,
                onTap: () {
                  Singleton.get().sharedPrefs.clear().then((v) {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  });
                }),
          ],
        );
      },
    ));
  }

  Widget _createHeader(AlumnoAcademico alumno) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(color: primaryColor),
      currentAccountPicture: Image.asset('Assets/logo_itsur.png'),
      accountName: Text(alumno != null ? alumno.nombre : ''),
      accountEmail: Text(alumno != null ? alumno.carrera : ''),
    );
  }

  Widget _createDrawerItem(
      {String iconPath, String text, String page, GestureTapCallback onTap}) {
    return Container(
      color: this.page == page ? Colors.grey[200] : null,
      child: ListTile(
        title: Row(
          children: <Widget>[
            ImageIcon(AssetImage(iconPath)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(text),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
