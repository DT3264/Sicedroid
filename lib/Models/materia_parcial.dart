class MateriaParcial {
  static List<MateriaParcial> emptyList = [];
  List<int> califUnidades = [];
  String nombre;
  String grupo;
  MateriaParcial.fromDynamic(dynamic m) {
    califUnidades = [];
    nombre = m['Materia'];
    grupo = m['Grupo'];
    for (var i = 1; i <= 13; i++) {
      if (m['C$i'] != null) {
        califUnidades.add(int.parse(m['C$i']));
      }
    }
  }
  @override
  String toString(){
    var s = '$nombre - $grupo - $califUnidades';
    return s;
  }
}
