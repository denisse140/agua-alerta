// lib/features/reports/screens/reports_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants.dart';
import '../providers/reports_provider.dart';
import '../models/report.dart';
import '../../auth/auth_provider.dart';

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reportes de Agua'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: reportsAsync.when(
        data: (reports) => _buildList(context, ref, reports),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 70, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text('No se pudieron cargar los reportes', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.read(reportsProvider.notifier).refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Report> reports) {
    if (reports.isEmpty) {
      return const Center(
        child: Text('No hay reportes en este momento', style: TextStyle(fontSize: 18)),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => await ref.read(reportsProvider.notifier).refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            ref.read(reportsProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: reports.length + 1,
          itemBuilder: (context, index) {
            if (index == reports.length) {
              final hasMore = ref.read(reportsProvider.notifier).hasMore;
              return hasMore
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox(height: 80);
            }

            final report = reports[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge de días sin agua 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            report.colonia,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBAE6FD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            report.tiempoSinAgua,
                            style: const TextStyle(
                              color: Color(0xFF0369A1),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Tipo de problema en rojo
                    Text(
                      report.tipoProblema,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Descripción
                    Text(
                      report.descripcion,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),

                    const SizedBox(height: 16),

                    // Fecha y cantidad de personas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          report.fecha,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.people_alt, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              report.confirmaciones.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}