import 'package:sicedroid/Models/promedio.dart';

import 'materia_kardex.dart';

class Kardex{
  List<MateriaKardex> materias;
  Promedio promedio;
  
  Kardex.fromDynamic(dynamic jsonObj){
    materias = [];
    var kardexList = jsonObj['lstKardex'] as List;
    kardexList.forEach((m)=>materias.add(MateriaKardex.fromDynamic
    (m)));
    
    var kardexMap = jsonObj['Promedio'];
    promedio = Promedio.fromDynamic(kardexMap);
  }
}