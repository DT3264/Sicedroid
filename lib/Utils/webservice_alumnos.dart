import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:xml2json/xml2json.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:sicedroid/Models/carga_academica.dart';
import 'package:sicedroid/Models/finales.dart';
import 'package:sicedroid/Models/parciales.dart';
import 'package:sicedroid/Models/alumno_academico.dart';
import 'package:sicedroid/Models/kardex.dart';
import 'package:sicedroid/Models/promedio.dart';
import 'package:sicedroid/Models/status.dart';

class WebServiceAlumnos {
  //var _url = 'http://sicenet.itsur.edu.mx/WS/WSAlumnos.asmx';
  var _url = 'http://6db0a5dc.ngrok.io/WS/WSAlumnos.asmx';
  final _dioClient = Dio();
  final _cookieJar = CookieJar();

  WebServiceAlumnos() {
    _dioClient.interceptors.add(CookieManager(_cookieJar));
  }

  Future<Status> login(String user, String pass) async {
    Status status = Status.fromDynamic({'acceso': false});
    var subUrl = 'accesoLogin';
    var data = {
      'strMatricula': user,
      'strContrasenia': pass,
      'tipoUsuario': '0'
    };
    var response = Response();
    response = await _dioClient
        .post('$_url/$subUrl', data: data)
        .catchError((e) => response = null);
    if (response == null) {
      return null;
    }
    var jsonData = response.data;

    if (jsonData != null || response.data['d'].toString().isNotEmpty) {
      jsonData = json.decode(jsonData['d']);
      status = Status.fromDynamic(jsonData);
    }
    return status;
  }

  Future<Parciales> califParciales() async {
    var subUrl = 'getCalifUnidadesByAlumno';
    var response = await _dioClient.post('$_url/$subUrl');
    var responseData = response.data as String;
    var jsonObj = getJsonFromXml(responseData);
    var jsonString = jsonObj['string']['\$'].toString();
    jsonString = jsonString.replaceAll('\\r\\n', '');
    jsonObj = json.decode(jsonString);
    var parciales = Parciales.fromDynamic(null);
    if (jsonObj != null) {
      parciales = Parciales.fromDynamic(jsonObj);
    }
    return parciales;
  }

  Future<Finales> califFinales() async {
    var subUrl = 'getAllCalifFinalByAlumnos';
    var data = {'bytModEducativo': '0'};
    var response = await _dioClient.post('$_url/$subUrl', data: data);
    var jsonObj =
        json.decode(response.data['d'].toString().replaceAll('\\r\\n', ''));
    var finales = Finales.fromDynamic(null);
    if (jsonObj != null) {
      finales = Finales.fromDynamic(jsonObj);
    }
    return finales;
  }

  Future<Kardex> kardexConPromedio() async {
    var subUrl = 'getAllKardexConPromedioByAlumno';
    var data = {'aluLineamiento': '1'};
    var response = await _dioClient.post('$_url/$subUrl', data: data);
    var responseData = response.data;
    var jsonObj = json.decode(responseData['d']);
    var kardex = Kardex.fromDynamic(jsonObj);
    return kardex;
  }

  Future<AlumnoAcademico> getAlumnoAcademicoWithLineamiento() async {
    var subUrl = 'getAlumnoAcademicoWithLineamiento';
    var response = await _dioClient.post('$_url/$subUrl');
    var jsonObj = getJsonFromXml(response.data);
    jsonObj = json.decode(jsonObj['string']['\$']);
    var alumno = AlumnoAcademico.fromDynamic(jsonObj);
    return alumno;
  }

  Future<Map<String, dynamic>> getMainPageData() async {
    var alumno = await getAlumnoAcademicoWithLineamiento();
    Singleton.get().alumnoAcademico = alumno;
    var promedio = await _getPromedioDetalle();
    return {"alumno": alumno, "promedio": promedio};
  }

  Future<CargaAcademica> getCargaAcademica() async {
    var subUrl = 'getCargaAcademicaByAlumno';
    var response = await _dioClient.post('$_url/$subUrl');
    var jsonObj = getJsonFromXml(response.data);
    var jsonString = jsonObj['string']['\$'].toString();
    jsonString = jsonString.replaceAll('\\r\\n', '');
    jsonObj = json.decode(jsonString);
    var carga = CargaAcademica.fromDynamic(jsonObj);
    return carga;
  }

  Future<Promedio> _getPromedioDetalle() async {
    var subUrl = 'getPromedioDetalleByAlumno';
    var response = await _dioClient.post('$_url/$subUrl');
    var jsonObj = getJsonFromXml(response.data);
    jsonObj = json.decode(jsonObj['string']['\$']);
    var promedio = Promedio.fromDynamic(jsonObj);
    return promedio;
  }

  void logout() async {
    Singleton.get().sharedPrefs.clear();
  }

  dynamic getJsonFromXml(String responseData) {
    var tokenize = Xml2Json();
    tokenize.parse(responseData);
    var jsonStr = tokenize.toBadgerfish();
    var jsonObj = json.decode(jsonStr);
    return jsonObj;
  }
}
