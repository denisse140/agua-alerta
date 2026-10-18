// lib/services/report_service.dart
// Aquí está toda la lógica de llamadas HTTP.
// Lo separé de la pantalla y del provider para que el código quede más limpio
// y sea más fácil de probar o cambiar después.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/reports/models/report.dart';

class ReportService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Obtiene una página de reportes
  Future<List<Report>> getReports({int page = 1, int limit = 15}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?_page=$page&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar reportes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Simula el envío de un nuevo reporte (por si en el futuro se amplía)
  Future<bool> createReport(String colonia, String descripcion) async {
    try {
      // En un proyecto real aquí iría un POST a la API
      await Future.delayed(const Duration(seconds: 1)); // Simulamos tiempo de red
      return true;
    } catch (e) {
      return false;
    }
  }
}