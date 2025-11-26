import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyDOa9uczTfF5tA6g-HumyziBiXWK5keTHc';

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
  }

  Future<List<String>> generateRecommendations({
    required List<Map<String, dynamic>> devices,
    required double totalDailyKWh,
    required int? monthlyBudget,
    String? jenisHunian,
    int? jumlahPenghuni,
    int? dayaListrik,
    String? golonganTarif,
    double? tarifPerKwh,
  }) async {
    try {
      // Build context for AI
      final deviceList = devices
          .map((d) {
            final kwh = (d['watt'] * d['hours'] / 1000).toStringAsFixed(2);
            return '${d['name']} (${d['watt']}W, ${d['hours']} jam/hari = $kwh kWh/hari)';
          })
          .join(', ');

      // Calculate estimated monthly cost
      final estimatedMonthlyCost = totalDailyKWh * 30 * (tarifPerKwh ?? 1500);

      final prompt =
          '''
Kamu adalah asisten SmartWatt yang membantu pengguna Indonesia menghemat listrik.

Data profil pengguna:
- Jenis hunian: ${jenisHunian ?? 'Tidak disebutkan'}
- Jumlah penghuni: ${jumlahPenghuni != null ? '$jumlahPenghuni orang' : 'Tidak disebutkan'}
- Daya listrik: ${dayaListrik != null ? '$dayaListrik VA' : 'Tidak disebutkan'}
- Golongan tarif PLN: ${golonganTarif ?? 'Tidak disebutkan'}
- Tarif per kWh: Rp ${tarifPerKwh?.toStringAsFixed(0) ?? '1500'}

Data penggunaan listrik:
- Total penggunaan harian: ${totalDailyKWh.toStringAsFixed(2)} kWh/hari
- Estimasi bulanan: ${(totalDailyKWh * 30).toStringAsFixed(1)} kWh/bulan
- Estimasi biaya bulanan: Rp ${(estimatedMonthlyCost / 1000).toStringAsFixed(0)}.000
- Budget yang ditetapkan: ${monthlyBudget != null ? 'Rp ${monthlyBudget ~/ 1000}.000' : 'Belum diatur'}
${monthlyBudget != null ? '- Status budget: ${estimatedMonthlyCost > monthlyBudget
                    ? 'OVER BUDGET ⚠️'
                    : estimatedMonthlyCost > monthlyBudget * 0.8
                    ? 'Mendekati limit'
                    : 'Aman'}' : ''}

Perangkat yang digunakan:
$deviceList

TUGAS:
Berikan 3 rekomendasi penghematan listrik yang:
1. Spesifik untuk perangkat yang mereka pakai
2. Sesuai dengan jenis hunian dan jumlah penghuni
3. Praktis dan bisa langsung diterapkan
4. Singkat (maksimal 20 kata per rekomendasi)
5. Dimulai dengan emoji yang relevan

Format: setiap rekomendasi 1 baris dengan emoji di awal.
Prioritaskan perangkat dengan konsumsi tertinggi.
Jika over budget, fokus pada cara menurunkan biaya drastis.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        return _getFallbackRecommendations();
      }

      // Parse response into list
      final recommendations = response.text!
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .where(
            (line) =>
                line.contains('•') ||
                line.contains('-') ||
                line.contains('*') ||
                RegExp(
                  r'^[\u{1F300}-\u{1F9FF}]',
                  unicode: true,
                ).hasMatch(line.trim()),
          )
          .map((line) => line.replaceAll(RegExp(r'^[•\-*]\s*'), '').trim())
          .take(3)
          .toList();

      if (recommendations.isEmpty) {
        return _getFallbackRecommendations();
      }

      return recommendations;
    } catch (e) {
      print('Gemini API Error: $e');
      return _getFallbackRecommendations();
    }
  }

  /// Fallback recommendations if API fails
  List<String> _getFallbackRecommendations() {
    return [
      '💡 Matikan perangkat yang tidak digunakan untuk hemat listrik',
      '❄️ Atur suhu AC di 24-26°C untuk efisiensi optimal',
      '⏰ Gunakan timer untuk perangkat yang sering lupa dimatikan',
    ];
  }
}
