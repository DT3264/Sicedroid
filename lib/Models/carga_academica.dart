import 'package:sicedroid/Models/materia_carga_academica.dart';

class CargaAcademica {
  List<MateriaCargaAcademica> materias = [];
  CargaAcademica.fromDynamic(dynamic jsonObj) {
    var objList = jsonObj as List;
    if (objList != null) {
      objList
          .forEach((m) => materias.add(MateriaCargaAcademica.fromDynamic(m)));
    }
  }
  List<MateriaCargaAcademica> getMateriasDelDia(
    String dia,
  ) {
    List<MateriaCargaAcademica> materiasDelDia = [];
    materias.forEach((m) => materiasDelDia.add(m));
    if (dia == 'Lunes') {
      materiasDelDia.removeWhere((m) => m.lunes.isEmpty);
      materiasDelDia.sort((m1, m2) => m1.lunes.compareTo(m2.lunes));
      materiasDelDia.forEach((m) {
        var datos = m.lunes.split(' ');
        m.horaDiaActual = datos[0];
        m.aulaDiaActual = datos[2];
      });
    } else if (dia == 'Martes') {
      materiasDelDia.removeWhere((m) => m.martes.isEmpty);
      materiasDelDia.sort((m1, m2) => m1.martes.compareTo(m2.martes));
      materiasDelDia.forEach((m) {
        var datos = m.martes.split(' ');
        m.horaDiaActual = datos[0];
        m.aulaDiaActual = datos[2];
      });
    } else if (dia == 'Miercoles') {
      materiasDelDia.removeWhere((m) => m.miercoles.isEmpty);
      materiasDelDia.sort((m1, m2) => m1.miercoles.compareTo(m2.miercoles));
      materiasDelDia.forEach((m) {
        var datos = m.miercoles.split(' ');
        m.horaDiaActual = datos[0];
        m.aulaDiaActual = datos[2];
      });
    } else if (dia == 'Jueves') {
      materiasDelDia.removeWhere((m) => m.jueves.isEmpty);
      materiasDelDia.sort((m1, m2) => m1.jueves.compareTo(m2.jueves));
      materiasDelDia.forEach((m) {
        var datos = m.jueves.split(' ');
        m.horaDiaActual = datos[0];
        m.aulaDiaActual = datos[2];
      });
    } else if (dia == 'Viernes') {
      materiasDelDia.removeWhere((m) => m.viernes.isEmpty);
      materiasDelDia.sort((m1, m2) => m1.viernes.compareTo(m2.viernes));
      materiasDelDia.forEach((m) {
        var datos = m.viernes.split(' ');
        m.horaDiaActual = datos[0];
        m.aulaDiaActual = datos[2];
      });
    } else if (dia == 'Sabado') {
      materiasDelDia.removeWhere((m) => m.sabado.isEmpty);
      materiasDelDia.sort((m1, m2) => m1.sabado.compareTo(m2.sabado));
      materiasDelDia.forEach((m) {
        var datos = m.sabado.split(' ');
        m.horaDiaActual = datos[0];
        m.aulaDiaActual = datos[2];
      });
    }
    return materiasDelDia;
  }
}
