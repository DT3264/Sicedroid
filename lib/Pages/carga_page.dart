import 'package:flutter/material.dart';
import 'package:sicedroid/Models/carga_academica.dart';
import 'package:sicedroid/Models/materia_carga_academica.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Widgets/back_button_handler.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';
import 'package:sicedroid/Utils/strings.dart' as strings;

class CargaPage extends StatefulWidget {
  static const String routeName = '/carga';
  @override
  _CargaPageState createState() => _CargaPageState();
}

class _CargaPageState extends State<CargaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carga Académica'),
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'HOY'),
              Tab(text: 'LUN'),
              Tab(text: 'MAR'),
              Tab(text: 'MIE'),
              Tab(text: 'JUE'),
              Tab(text: 'VIE'),
              Tab(text: 'SAB')
            ],
          ),
        ),
        drawer: MainDrawer(
          context: context,
          page: Routes.carga,
        ),
        body: BackButtonHandler(
          context,
          child: FutureBuilder(
            future: Singleton.get().webServiceAlumnos.getCargaAcademica(),
            builder: (buildContext, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return InfiniteLoading();
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text(strings.sinInternet));
              }
              return TabBarView(
                children: <Widget>[
                  getHoy(carga: snapshot.data),
                  getSingleDay(dia: 1, carga: snapshot.data, showDate: false),
                  getSingleDay(dia: 2, carga: snapshot.data, showDate: false),
                  getSingleDay(dia: 3, carga: snapshot.data, showDate: false),
                  getSingleDay(dia: 4, carga: snapshot.data, showDate: false),
                  getSingleDay(dia: 5, carga: snapshot.data, showDate: false),
                  getSingleDay(dia: 6, carga: snapshot.data, showDate: false)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getHoy({@required CargaAcademica carga}) {
    var dia = DateTime.now().weekday;
    if (dia != 7) {
      return getSingleDay(dia: dia, carga: carga, showDate: true);
    } else {
      return Center(
        child: Text('Sin horario el domingo'),
      );
    }
  }

  Widget getSingleDay(
      {@required int dia,
      @required CargaAcademica carga,
      @required bool showDate}) {
    var hoy = DateTime.now();
    List<MateriaCargaAcademica> materias =
        carga.getMateriasDelDia(getDiaDeInt(dia));
    List<Widget> materiasWidgets = [];
    materiasWidgets.add(Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width * .8,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5),
      child: Center(
          child: Text(
        '${getDiaDeInt(dia)}' +
            (showDate ? ': ${hoy.day}/${hoy.month}/${hoy.year}' : ''),
        style: TextStyle(color: Colors.white),
      )),
    ));
    for (var i = 0; i < materias.length; i++) {
      materiasWidgets.add(getMateriaRow(materias[i], i == materias.length - 1));
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(children: materiasWidgets),
      ),
    );
  }

  Widget getMateriaRow(MateriaCargaAcademica m, bool isLast) {
    var color = Colors.yellow[700];
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        padding: EdgeInsets.all(10),
        decoration: ShapeDecoration(
            shape: BorderDirectional(
          top: BorderSide(color: color),
          bottom: isLast ? BorderSide(color: color) : BorderSide.none,
          start: BorderSide(color: color),
          end: BorderSide(color: color),
        )),
        child: Column(
          children: <Widget>[
            Text(m.materia),
            Text(m.docente),
            Text(m.horaDiaActual),
            Text('Aula: ${m.aulaDiaActual}')
          ],
        ));
  }

  String getDiaDeInt(int dia) {
    if (dia == 1) {
      return 'Lunes';
    } else if (dia == 2) {
      return 'Martes';
    } else if (dia == 3) {
      return 'Miercoles';
    } else if (dia == 4) {
      return 'Jueves';
    } else if (dia == 5) {
      return 'Viernes';
    } else if (dia == 6) {
      return 'Sabado';
    }
    return 'Domingo';
  }
}
