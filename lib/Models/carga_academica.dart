import 'package:sicedroid/Models/materia_carga_academica.dart';

class CargaAcademica{
  List<MateriaCargaAcademica> materias = [];
  CargaAcademica.fromDynamic(dynamic jsonObj){
    var objList = jsonObj as List;
    if (objList != null) {
      objList.forEach(
          (m) => materias.add(MateriaCargaAcademica.fromDynamic(m)));
    }
  }
}