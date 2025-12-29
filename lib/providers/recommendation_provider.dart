import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/gemini_service.dart';

class RecommendationProvider with ChangeNotifier {
  final AppDatabase _database;
  final GeminiService _geminiService;

  List<String> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  RecommendationProvider(this._database, this._geminiService);

  Future<void> fetchRecommendations(int currentUserId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final devices =
          await _database.devicesDao.getDevicesForUser(currentUserId);
      final user =
          await _database.usersDao.getUserById(currentUserId);
      final budget =
          await _database.getLatestBudget(currentUserId);

      if (user == null || devices.isEmpty) {
        throw Exception('Data pengguna atau perangkat belum lengkap');
      }

      // 🔹 HITUNG TOTAL KWH
      double totalDailyKWh = 0;
      for (var d in devices) {
        totalDailyKWh += (d.watt * d.hoursPerDay) / 1000;
      }

      // 🔹 ESTIMASI BIAYA BULANAN
      final tarif = user.tarifPerKwh ?? 1352;
      final estimasiBulanan = totalDailyKWh * 30 * tarif;

      final bool overBudget = budget != null &&
          estimasiBulanan > budget.budget;

      final String statusKonsumsi =
          overBudget ? 'OVER_BUDGET' : 'AMAN';

      // 🔹 CARI PERANGKAT PALING BOROS
      final mostWasteful = devices.reduce(
        (a, b) =>
            (a.watt * a.hoursPerDay) >
                    (b.watt * b.hoursPerDay)
                ? a
                : b,
      );

      // 🔹 PANGGIL GEMINI
      _recommendations =
          await _geminiService.generateRecommendations(
        statusKonsumsi: statusKonsumsi,
        perangkatBoros: mostWasteful.name,
        jenisHunian: user.jenisHunian ?? '-',
        jumlahPenghuni: user.jumlahPenghuni ?? 1,
      );
    } catch (e) {
      _errorMessage =
          'Gagal mendapatkan rekomendasi: ${e.toString()}';
      _recommendations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
