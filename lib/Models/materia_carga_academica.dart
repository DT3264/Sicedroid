class MateriaCargaAcademica {
  String semipresencial;
  String observaciones;
  String docente;
  String clvOficial;
  String sabado;
  String viernes;
  String jueves;
  String miercoles;
  String martes;
  String lunes;
  String estadoMateria;
  int creditosMateria;
  String materia;
  String grupo;

  String aulaDiaActual;//Contiene el aula del día actual
  String horaDiaActual;//Contiene la hora del día actual 
  //provista en CargaAcademica->getMateriasDelDia()

  MateriaCargaAcademica.fromDynamic(dynamic c) {
    semipresencial = c['Semipresencial'];
    observaciones = c['Observaciones'];
    docente = c['Docente'];
    clvOficial = c['clvOficial'];
    sabado = c['Sabado'];
    viernes = c['Viernes'];
    jueves = c['Jueves'];
    miercoles = c['Miercoles'];
    martes = c['Martes'];
    lunes = c['Lunes'];
    estadoMateria = c['EstadoMateria'];
    creditosMateria = int.parse(c['CreditosMateria'].toString());
    materia = c['Materia'];
    grupo = c['Grupo'];
  }
  @override
  String toString() {
    var s =
        'Materia: $materia, Clave: $clvOficial, Grupo: $grupo, Docente: $docente, Lunes: $lunes, Martes: $martes';
    s +=
        ', Miercoles: $miercoles, Jueves: $jueves, Viernes: $viernes, Sabado: $sabado, EstadoMateria: $estadoMateria';
    s +=
        ', CreditosMateria: $creditosMateria, Semipresencial: $semipresencial, Obeservaciones: $observaciones';
    return s;
  }
}
