import 'package:flutter/material.dart';
import 'package:sicedroid/Models/alumno_academico.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Utils/theme.dart';
import 'package:sicedroid/Routes/routes.dart';

class MainDrawer extends StatelessWidget {
  final String page;
  MainDrawer({@required BuildContext context, @required this.page});
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder(
      future: Singleton.get().getAlumno(),
      builder: (buildContext, snapshot) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(snapshot.data),
            _createDrawerItem(
                iconPath: 'assets/datos_academicos.png',
                text: 'Datos Académicos',
                page: Routes.main,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.main);
                }),
            _createDrawerItem(
                iconPath: 'assets/carga_academica.png',
                text: 'Carga Académica',
                page: Routes.carga,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.carga);
                }),
            _createDrawerItem(
                iconPath: 'assets/calificaciones_parciales.png',
                text: 'Calificaciones Parciales',
                page: Routes.parciales,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.parciales);
                }),
            _createDrawerItem(
                iconPath: 'assets/calificaciones_finales.png',
                text: 'Calificaiones Finales',
                page: Routes.finales,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.finales);
                }),
            _createDrawerItem(
                iconPath: 'assets/kardex.png',
                text: 'Kardex',
                page: Routes.kardex,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.kardex);
                }),
            _createDrawerItem(
                iconPath: 'assets/salir.png',
                text: 'Salir',
                page: Routes.login,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (localContext) {
                        return AlertDialog(
                          title: Text('Salir'),
                          content: Text('¿Desea cerrar sesión?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Sí'),
                              onPressed: () {
                                Singleton.get().sharedPrefs.clear().then((v) {
                                  Navigator.popUntil(context, (route) {
                                    return route.isFirst;
                                  });
                                });
                              },
                            ),
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(localContext).pop();
                              },
                            )
                          ],
                        );
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
      currentAccountPicture: Image.asset('assets/logo_itsur.png'),
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
