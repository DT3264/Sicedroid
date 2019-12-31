import 'package:flutter/material.dart';
import 'package:sicedroid/Models/finales.dart';
import 'package:sicedroid/Models/materia_final.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Widgets/back_button_handler.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';
import 'package:sicedroid/Utils/theme.dart' as theme;

class FinalesPage extends StatefulWidget {
  static const String routeName = '/finales';
  @override
  _FinalesPageState createState() => _FinalesPageState();
}

class _FinalesPageState extends State<FinalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificaciones Finales'),
      ),
      drawer: MainDrawer(
        context: context,
        page: Routes.finales,
      ),
      body: BackButtonHandler(context,
          child: FutureBuilder(
            future: Singleton.get().webServiceAlumnos.califFinales(),
            builder: (buildContext, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return InfiniteLoading();
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text('Conexión fallida, intnete más tarde'));
              }
              return SingleChildScrollView(child: _getTable(snapshot.data));
            },
          )),
    );
  }

  Widget _getTable(Finales finales) {
    var width = MediaQuery.of(context).size.width;
    List<TableRow> tableRows = [];
    tableRows.add(TableRow(children: <Widget>[
      _headerColumn('Materia'),
      _headerColumn('Calificación'),
      _headerColumn('Acreditación')
    ]));
    finales.finales.sort((m1, m2) => m1.grupo.compareTo(m2.grupo));
    finales.finales.forEach((m) => tableRows.add(_materiaColumn(materia: m)));
    //Entre los width-s del margen y las columnas, el acumulado es 1
    return Container(
      margin: EdgeInsets.only(left: width * .01, right: width * .01, top: 10),
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

  TableRow _materiaColumn({@required MateriaFinal materia}) {
    var height = 50.0;
    return TableRow(children: <Widget>[
      Container(
        height: height,
        child: Center(
            child: Text(
          materia.materia,
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
            materia.acreditado,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }
}
