// lib/features/reports/models/report.dart
// Modelo de los reportes de falta de agua.
// Lo hice sencillo pero con todos los campos que voy a mostrar en el listado.
// Uso los datos de jsonplaceholder (title y body) y agrego campos simulados.

class Report {
  final int id;
  final String colonia;
  final String descripcion;
  final String tiempoSinAgua;
  final String tipoProblema;
  final String fecha;
  final int confirmaciones;

  Report({
    required this.id,
    required this.colonia,
    required this.descripcion,
    required this.tiempoSinAgua,
    required this.tipoProblema,
    required this.fecha,
    this.confirmaciones = 0,
  });

  // Convierte el JSON de la API (jsonplaceholder) en un Report
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? 0,
      colonia: json['title'] ?? 'Colonia sin nombre',
      descripcion: json['body'] ?? 'Sin descripción',
      tiempoSinAgua: _generateRandomTime(json['id']),
      tipoProblema: json['id'] % 3 == 0
          ? "Falta total de suministro"
          : json['id'] % 2 == 0
              ? "Baja presión"
              : "Fuga de tubería",
      fecha: "24/10/2026",
      confirmaciones: (json['id'] % 12) + 3,
    );
  }

  // Función auxiliar para simular diferentes tiempos
  static String _generateRandomTime(int id) {
    final days = (id % 7) + 1;
    return "$days ${days == 1 ? 'día' : 'días'} sin agua";
  }

  // Para cuando queramos crear un reporte nuevo (futuro)
  Report copyWith({
    String? colonia,
    String? descripcion,
    String? tiempoSinAgua,
    String? tipoProblema,
  }) {
    return Report(
      id: id,
      colonia: colonia ?? this.colonia,
      descripcion: descripcion ?? this.descripcion,
      tiempoSinAgua: tiempoSinAgua ?? this.tiempoSinAgua,
      tipoProblema: tipoProblema ?? this.tipoProblema,
      fecha: fecha,
      confirmaciones: confirmaciones,
    );
  }
}