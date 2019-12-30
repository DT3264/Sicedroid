import 'package:flutter/material.dart';
import 'package:sicedroid/Models/carga_academica.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Widgets/infinite_loading.dart';
import 'package:sicedroid/Widgets/main_drawer.dart';

class CargaPage extends StatefulWidget {
  static const String routeName = '/carga';
  @override
  _CargaPageState createState() => _CargaPageState();
}

class _CargaPageState extends State<CargaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carga Académica'),
      ),
      drawer: MainDrawer(
        context: context,
        page: Routes.carga,
      ),
      body: FutureBuilder(
        future: Singleton.get().webServiceAlumnos.getCargaAcademica(),
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

  Widget _getBody(CargaAcademica carga) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.green,
        child: Text(carga.materias.toString()),
      ),
    );
  }
}
