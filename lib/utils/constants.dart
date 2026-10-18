// lib/utils/constants.dart
// Aquí guardo todos los valores que se repiten en varias pantallas
// (colores, textos, tamaños). 

import 'package:flutter/material.dart';

class AppColors {
  // Colores principales basados en el diseño de Stitch
  static const Color primary = Color(0xFF1565C0);     
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color accent = Color(0xFF03A9F4);      
  static const Color background = Color(0xFFF5F7FA);
  static const Color textDark = Color(0xFF263238);
  static const Color textLight = Color(0xFF607D8B);
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF4CAF50);
}

class AppStrings {
  static const String appName = "AguaAlerta";
  static const String tagline = "Monitoreo ciudadano de agua potable";

  // Textos de Login
  static const String loginTitle = "Bienvenido";
  static const String loginSubtitle = "Ingresa para reportar o consultar reportes";
  static const String emailHint = "Correo electrónico";
  static const String passwordHint = "Contraseña";
  static const String loginButton = "Iniciar Sesión";
  static const String noAccount = "¿No tienes cuenta?";
  static const String registerLink = "Regístrate";

  // Textos de Registro
  static const String registerTitle = "Crear cuenta";
  static const String fullNameHint = "Nombre completo";
  static const String confirmPasswordHint = "Confirmar contraseña";
  static const String termsText = "Acepto los términos y condiciones";
  static const String registerButton = "Registrarme";

  // Textos del Listado
  static const String reportsTitle = "Reportes de Agua";
  static const String lastUpdate = "Última actualización:";
  static const String noReports = "No hay reportes en tu zona por el momento.\n¡Sé el primero en reportar!";
  static const String retryButton = "Reintentar";
  static const String logout = "Cerrar sesión";
}

class AppConstants {
  static const int passwordMinLength = 8;
  static const Duration fakeLoadingDuration = Duration(seconds: 2);
  static const int paginationLimit = 15;
}