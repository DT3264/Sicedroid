import 'package:flutter/material.dart';
import 'package:sicedroid/Models/kardex.dart';
import 'package:sicedroid/Models/materia_kardex.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Widgets/back_button_handler.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';
import 'package:sicedroid/Utils/theme.dart' as theme;

class KardexPage extends StatefulWidget {
  static const String routeName = '/kardex';
  @override
  _KardexPageState createState() => _KardexPageState();
}

class _KardexPageState extends State<KardexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kardex'),
      ),
      drawer: MainDrawer(
        context: context,
        page: Routes.kardex,
      ),
      body: BackButtonHandler(context,
          child: FutureBuilder(
            future: Singleton.get().webServiceAlumnos.kardexConPromedio(),
            builder: (buildContext, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return InfiniteLoading();
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text('Conexión fallida, intnete más tarde'));
              }
              return _getTable(snapshot.data);
            },
          )),
    );
  }

  Widget _getTable(Kardex kardex) {
    var width = MediaQuery.of(context).size.width;
    List<TableRow> tableRows = [];
    tableRows.add(TableRow(children: <Widget>[
      _headerColumn('Materia'),
      _headerColumn('Calificación'),
      _headerColumn('Acreditación')
    ]));
    kardex.materias.sort((m1, m2) => m1.clvMat.compareTo(m2.clvMat));
    kardex.materias.forEach((m) => tableRows.add(_materiaColumn(materia: m)));
    //Entre los width-s del margen y las columnas, el acumulado es 1
    return kardex.materias.length > 0
        ? SingleChildScrollView(
            child: Container(
            margin: EdgeInsets.only(
                left: width * .01, right: width * .01, top: 10, bottom: 5),
            child: Table(
              columnWidths: {
                0: FixedColumnWidth(width * .48),
                1: FixedColumnWidth(width * .25),
                2: FixedColumnWidth(width * .25),
              },
              children: tableRows,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.green[600]),
            ),
          ))
        : Center(
            child: Text('Sin datos aún'),
          );
  }

  Widget _headerColumn(String text) {
    return Container(
        color: Colors.green,
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Colors.white),
        )));
  }

  TableRow _materiaColumn({@required MateriaKardex materia}) {
    var height = 50.0;
    return TableRow(children: <Widget>[
      Container(
        height: height,
        child: Center(
            child: Text(
          materia.materia + '\n' + materia.clvMat,
          textAlign: TextAlign.center,
        )),
      ),
      Container(
        height: height,
        color: theme.getColorByCalif(materia.calif),
        child: Center(
          child: Text(
            materia.calif.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Container(
        height: height,
        child: Center(
          child: Text(
            materia.acred,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    ]);
  }
}
