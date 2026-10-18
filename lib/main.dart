// lib/main.dart
// Este es el archivo principal de la app.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'utils/constants.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/auth_provider.dart';
import 'features/reports/screens/reports_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authNotifierProvider);

    final GoRouter router = GoRouter(
      initialLocation: isLoggedIn ? '/reports' : '/login',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportsListScreen(),
        ),
      ],
      redirect: (context, state) {
        final loggedIn = ref.read(authNotifierProvider);
        final goingToLogin = state.matchedLocation == '/login';
        final goingToRegister = state.matchedLocation == '/register';

        if (!loggedIn && !goingToLogin && !goingToRegister) {
          return '/login';
        }
        if (loggedIn && (goingToLogin || goingToRegister)) {
          return '/reports';
        }
        return null;
      },
    );

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      routerConfig: router,
    );
  }
}