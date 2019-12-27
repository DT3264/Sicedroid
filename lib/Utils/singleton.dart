import 'package:sicedroid/Utils/webservice_alumnos.dart';

class Singleton {

  static final Singleton _singleton = new Singleton._internal();

  WebServiceAlumnos webServiceAlumnos;

  static Singleton get() {
    return _singleton;
  }

  Singleton._internal() {
    webServiceAlumnos = WebServiceAlumnos();
  }
}