import 'package:sicedroid/Models/materia_final.dart';

class Finales {
  List<MateriaFinal> finales = [];
  Finales.fromDynamic(dynamic jsonObj) {
    if (jsonObj != null) {
      var objList = jsonObj as List;
      objList.forEach((m) => finales.add(MateriaFinal.fromDynamic(m)));
      finales.sort((m1, m2) => m1.materia.compareTo(m2.materia));
    }
  }
}
