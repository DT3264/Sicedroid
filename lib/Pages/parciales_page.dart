import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:sicedroid/Models/parciales.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Widgets/back_button_handler.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';
import 'package:sicedroid/Utils/theme.dart' as theme;
import 'package:sicedroid/Utils/strings.dart' as strings;

class ParcialesPage extends StatefulWidget {
  static const String routeName = '/parciales';
  @override
  _ParcialesPage createState() => _ParcialesPage();
}

class _ParcialesPage extends State<ParcialesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificaciones parciales'),
      ),
      drawer: MainDrawer(
        context: context,
        page: Routes.parciales,
      ),
      body: BackButtonHandler(
        context,
        child: FutureBuilder(
            future: Singleton.get().webServiceAlumnos.califParciales(),
            builder: (buildContext, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return InfiniteLoading();
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text(strings.sinInternet));
              }
              return _getBody(snapshot.data);
            }),
      ),
    );
  }

  Widget _getBody(Parciales parciales) {
    List<Widget> materias = [];
    parciales.parciales.sort((p1, p2) => p1.grupo.compareTo(p2.grupo));
    parciales.parciales.forEach((p) {
      materias.add(_materiaTile(p.nombre, p.califUnidades));
    });
    return materias.length > 0
        ? SingleChildScrollView(child: Column(children: materias))
        : Center(
            child: Text('Sin datos aún'),
          );
  }

  Widget _materiaTile(String materia, List<int> calificaciones) {
    List<Widget> unidades = [];
    for (var i = 0; i < calificaciones.length; i++) {
      unidades.add(_unidadTile(i + 1, calificaciones[i]));
    }
    return ConfigurableExpansionTile(
      headerExpanded: _getHeader(materia, true),
      header: _getHeader(materia, false),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(children: unidades),
        )
      ],
    );
  }

  Widget _getHeader(String materia, bool expanded) {
    return Flexible(
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          color: Colors.green,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    materia,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    (expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    size: 40,
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget _unidadTile(int unidad, int calif) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Center(
                  child: Text(
            'Unidad $unidad',
            style: TextStyle(fontSize: 20),
          ))),
          Expanded(
              child: Container(
                  color: theme.getColorByCalif(calif),
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  margin: EdgeInsets.only(top: 1),
                  child: Center(
                      child: Text(
                    '$calif',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))))
        ],
      ),
    );
  }
}
