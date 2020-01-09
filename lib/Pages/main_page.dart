import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicedroid/Models/alumno_academico.dart';
import 'package:sicedroid/Models/promedio.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/orientations.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Utils/theme.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main';
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  AlumnoAcademico alumno;

  @override
  void initState() {
    super.initState();
    enableRotation();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos académicos'),
      ),
      drawer: MainDrawer(
        context: context,
        page: Routes.main,
      ),
      body: FutureBuilder(
        future: Singleton.get().webServiceAlumnos.getMainPageData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return InfiniteLoading();
          } else {
            if (!snapshot.hasData) {
              return Center(child: Text('Conexión fallida, intnete más tarde'));
            }
            var alumno = snapshot.data['alumno'] as AlumnoAcademico;
            var promedio = snapshot.data['promedio'] as Promedio;
            return WillPopScope(
              onWillPop: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: width * .8,
                      color: primaryColor,
                      child: Text(
                        'DATOS DEL ALUMNO',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    _localText('${alumno.matricula}'),
                    _localText('${alumno.carrera}'),
                    _localText('Especialidad: '),
                    _localText('${alumno.especialidad}'),
                    _localText('${alumno.nombre}'),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: width * .8,
                      color: primaryColor,
                      child: Text(
                        'ESTATUS ACADÉMICO',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    _localText(
                        'Estatus: ${alumno.estatus == "VI" ? "VIGENTE" : "NO VIGENTE"}'),
                    _localText('Inscrito: ${alumno.inscrito ? "SI" : "NO"}'),
                    _localText('Semestre actual: ${alumno.semActual}'),
                    _localText('Promedio actual: ${promedio.promedioGral}'),
                    _localText('Créditos actuales: ${alumno.cdtosActuales}'),
                    _localText(
                        'Créditos acumulados: ${alumno.cdtosAcumulados}'),
                    _localText(
                        'Progreso de la carrera: ${promedio.avanceCdts.round()}%'),
                    Padding(
                      child: LinearProgressIndicator(
                        value: promedio.avanceCdts / 100,
                      ),
                      padding:
                          EdgeInsets.fromLTRB(width * .1, 0, width * .1, 10),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: width * .8,
                      color: primaryColor,
                      child: Text(
                        'DATOS DE REINSCRIPCIÓN',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    _localText('FECHA'),
                    _localText(
                        '${alumno.fechaReins != null && alumno.fechaReins.isNotEmpty ? alumno.fechaReins : "NO ASIGNADA"}'),
                    _localText('ADEUDO(S)'),
                    _localText(
                        '${alumno.adeudo ? alumno.adeudoDescripcion : "NINGUNO"}'),
                  ])),
            );
          }
        },
      ),
    );
  }

  Widget _localText(String text) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ));
  }
}
