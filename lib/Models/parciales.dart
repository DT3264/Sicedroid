import 'package:sicedroid/Models/materia_parcial.dart';

class Parciales {
  List<MateriaParcial> parciales = [];
  Parciales.fromDynamic(dynamic p) {
    if (p!=null) {
      var objList = p as List;
      objList.forEach((m) => parciales.add(MateriaParcial.fromDynamic(m)));
      parciales.sort((m1, m2) => m1.nombre.compareTo(m2.nombre));
    }
  }
}
