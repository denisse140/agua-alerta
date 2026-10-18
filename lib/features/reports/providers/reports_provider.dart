// lib/features/reports/providers/reports_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/report_service.dart';
import '../models/report.dart';

final reportsProvider = AsyncNotifierProvider<ReportsNotifier, List<Report>>(
  ReportsNotifier.new,
);

class ReportsNotifier extends AsyncNotifier<List<Report>> {
  final ReportService _service = ReportService();

  int _currentPage = 1;
  bool _hasMore = true;
  static const int _limit = 15;

  @override
  Future<List<Report>> build() async {
    _currentPage = 1;
    _hasMore = true;
    return _fetchReports(page: 1);
  }

  Future<List<Report>> _fetchReports({required int page}) async {
    try {
      return await _service.getReports(page: page, limit: _limit);
    } catch (e) {
      rethrow;
    }
  }

  // Se llama cuando el usuario hace scroll cerca del final
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    // Guardo los datos actuales antes de poner el estado de carga
    final previousData = state.valueOrNull ?? [];
    state = const AsyncLoading();

    try {
      final newReports = await _fetchReports(page: _currentPage + 1);

      _hasMore = newReports.length == _limit;
      if (_hasMore) _currentPage++;

      state = AsyncData([...previousData, ...newReports]);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // Para refrescar toda la lista cuando se hace pull to refresh
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchReports(page: 1));
  }

  // Getter que usa la pantalla para saber si debe mostrar el loader al final
  bool get hasMore => _hasMore;
}