import 'package:shared_preferences/shared_preferences.dart';
import 'package:sicedroid/Models/alumno_academico.dart';
import 'package:sicedroid/Utils/webservice_alumnos.dart';

class Singleton {

  static final Singleton _singleton = new Singleton._internal();

  WebServiceAlumnos webServiceAlumnos;
  SharedPreferences sharedPrefs;
  AlumnoAcademico alumnoAcademico;

  static Singleton get() {
    return _singleton;
  }

  Singleton._internal() {
    webServiceAlumnos = WebServiceAlumnos();
  }
  Future<void> initSharedPrefs() async{
    sharedPrefs = await SharedPreferences.getInstance();
  }
  Future<AlumnoAcademico> getAlumno() async{
    if(alumnoAcademico == null){
      alumnoAcademico = await webServiceAlumnos.getAlumnoAcademicoWithLineamiento();
    }
    return alumnoAcademico;
  }
}