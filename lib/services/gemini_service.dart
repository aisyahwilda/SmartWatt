import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String _apiKey;

  GeminiService() : _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '' {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY belum diisi di file .env');
    }
  }

  /// METHOD YANG DIPANGGIL PROVIDER (INI YANG KEMARIN ERROR)
  Future<List<String>> generateRecommendations({
    required String statusKonsumsi,
    required String perangkatBoros,
    required String jenisHunian,
    required int jumlahPenghuni,
  }) async {
    final prompt =
        """
Kamu adalah asisten SmartWatt.

DATA PENGGUNA:
- Jenis hunian: $jenisHunian
- Jumlah penghuni: $jumlahPenghuni orang
- Status konsumsi listrik: $statusKonsumsi
- Perangkat paling boros: $perangkatBoros

TUGAS:
Berikan 3 rekomendasi penghematan listrik yang:
1. Fokus pada perangkat paling boros
2. Relevan untuk rumah tangga di Indonesia
3. Mudah diterapkan
4. Maksimal 20 kata per rekomendasi
5. Setiap baris diawali emoji

FORMAT OUTPUT:
Hanya 3 baris.
""";

    try {
      final url = Uri.parse(
        // MODEL PALING AMAN (kalau error → fallback)
        'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$_apiKey',
      );

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        print('❌ [Gemini] API Error: ${response.statusCode}');
        print('📋 Body: ${response.body.substring(0, 200)}');
        return _fallback(perangkatBoros);
      }

      final data = jsonDecode(response.body);
      final text =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

      if (text.isEmpty) {
        print('⚠️ [Gemini] Response text kosong!');
        print('📋 Full response: ${response.body.substring(0, 300)}');
      }

      final lines = text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .take(3)
          .toList();

      if (lines.isEmpty) {
        print('⚠️ [Gemini] Parsing gagal, lines kosong → fallback');
      } else {
        print('✅ [Gemini] Successfully parsed ${lines.length} recommendations');
      }

      return lines.isNotEmpty ? lines : _fallback(perangkatBoros);
    } catch (e, stack) {
      print('❌ [Gemini] Exception: $e');
      print('📋 Stack: ${stack.toString().split('\n').take(3).join('\n')}');
      return _fallback(perangkatBoros);
    }
  }

  List<String> _fallback(String perangkatBoros) {
    return [
      "💡 Kurangi durasi penggunaan $perangkatBoros untuk menekan konsumsi listrik",
      "⏱️ Gunakan timer agar $perangkatBoros tidak menyala terlalu lama",
      "🔌 Matikan $perangkatBoros saat tidak digunakan",
    ];
  }
}
