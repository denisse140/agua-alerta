// lib/features/auth/auth_provider.dart
// Este provider maneja el estado de autenticación (si el usuario está logueado).
// Lo uso en main.dart y en las pantallas de login y registro.
// Decidí hacerlo simple pero funcional para el parcial.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';

final authStateProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Al iniciar la app nadie está logueado
  }

  // Simula el login (en un proyecto real iría a una API)
  Future<bool> login(String email, String password) async {
    state = true; // Cambiamos el estado a logueado
    await Future.delayed(AppConstants.fakeLoadingDuration); // Simulamos tiempo de red
    return true;
  }

  // Simula el registro
  Future<bool> register(String fullName, String email, String password) async {
    state = true;
    await Future.delayed(AppConstants.fakeLoadingDuration);
    return true;
  }

  void logout() {
    state = false;
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, bool>(
  () => AuthNotifier(),
);