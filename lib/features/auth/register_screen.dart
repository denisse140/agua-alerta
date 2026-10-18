// lib/features/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../utils/constants.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _acceptTerms = false;
  bool _isLoading = false;

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirme su contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.register(
      _fullNameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      context.go('/reports');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.water_drop, size: 90, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Crear cuenta",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const Center(
                  child: Text(
                    "Únete y ayuda a tu comunidad",
                    style: TextStyle(fontSize: 16, color: AppColors.textLight),
                  ),
                ),
                const SizedBox(height: 40),

                AuthTextField(
                  label: "Nombre completo",
                  hintText: "Nombre completo",
                  controller: _fullNameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Ingrese su nombre' : null,
                ),

                AuthTextField(
                  label: "Correo electrónico",
                  hintText: "Correo electrónico",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingrese su correo';
                    if (!value.contains('@')) return 'Ingrese un correo válido';
                    return null;
                  },
                ),

                AuthTextField(
                  label: "Contraseña",
                  hintText: "Contraseña",
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingrese una contraseña';
                    if (value.length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),

                AuthTextField(
                  label: "Confirmar contraseña",
                  hintText: "Confirmar contraseña",
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _validateConfirmPassword,
                ),

                CheckboxListTile(
                  value: _acceptTerms,
                  onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                  title: const Text("Acepto los términos y condiciones"),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Registrarme"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}