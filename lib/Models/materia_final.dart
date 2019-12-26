class MateriaFinal{
  static List<MateriaFinal> emptyList = [];
  int calif;
  String acreditado;
  String grupo;
  String materia;
  MateriaFinal.fromDynamic(dynamic m){
    calif = int.parse(m['calif'].toString());
    acreditado = m['acred'].toString();
    grupo = m['grupo'];
    materia = m['materia'];
  }

  @override
  String toString() {
    return 'Materia: $materia, Calificación: $calif, Acreditado: $acreditado, grupo: $grupo';
  }
}