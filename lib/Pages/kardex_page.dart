import 'package:flutter/material.dart';
import 'package:sicedroid/Models/kardex.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';

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
      body: FutureBuilder(
        future: Singleton.get().webServiceAlumnos.kardexConPromedio(),
        builder: (buildContext, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return InfiniteLoading();
          } else if (!snapshot.hasData) {
            return Center(child: Text('Conexión fallida, intnete más tarde'));
          }
          return _getBody(snapshot.data);
        },
      ),
    );
  }

  Widget _getBody(Kardex kardex) {
    return Container(
      color: Colors.cyan,
      child: Column(
        children: <Widget>[
          Text(kardex.materias.toString()),
          Text(kardex.promedio.toString())
        ],
      ),
    );
  }
}
