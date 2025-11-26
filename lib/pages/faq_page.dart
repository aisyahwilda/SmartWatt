import 'package:flutter/material.dart';
import 'package:smartwatt_app/constants/colors_app.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Apa itu SmartWatt?',
      'answer':
          'SmartWatt adalah aplikasi untuk memantau penggunaan listrik harian, menghitung estimasi biaya, dan memberikan rekomendasi penghematan berdasarkan perangkat yang kamu gunakan.',
    },
    {
      'question': 'Bagaimana SmartWatt menghitung pemakaian listrik?',
      'answer':
          'SmartWatt menghitung penggunaan listrik berdasarkan:\n\n• Daya perangkat (Watt)\n• Durasi pemakaian (jam)\n• Tarif listrik rumahmu\n\nRumusnya: kWh = (Watt × jam pemakaian) ÷ 1000',
    },
    {
      'question': 'Apa itu kWh?',
      'answer':
          'kWh (kilo Watt hour) adalah satuan energi listrik yang digunakan PLN untuk menghitung jumlah energi yang kamu pakai setiap hari.',
    },
    {
      'question': 'Apa itu daya listrik (VA)?',
      'answer':
          'VA adalah kapasitas listrik di rumahmu. Semakin besar VA (900 VA, 1300 VA, 2200 VA), semakin banyak perangkat yang bisa dipakai bersamaan tanpa listrik turun.',
    },
    {
      'question': 'Bagaimana cara menambahkan perangkat di SmartWatt?',
      'answer':
          'Kamu cukup memasukkan:\n\n• Nama perangkat\n• Watt perangkat\n• Durasi pemakaian\n\nLalu SmartWatt menghitung otomatis konsumsi harian dan bulanan.',
    },
    {
      'question': 'Apa fungsi fitur Rekomendasi Penghematan?',
      'answer':
          'Fitur ini memakai AI untuk memberikan saran hemat listrik sesuai pola penggunaan perangkat, jumlah penghuni, dan tarif listrik rumahmu.',
    },
    {
      'question': 'Bagaimana cara mengatur budget listrik bulanan?',
      'answer':
          'Di menu Budget, masukkan jumlah anggaranmu per bulan. SmartWatt akan memberi peringatan jika pemakaian mendekati atau melewati batas budget.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // FAQ Items
          ..._faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            final isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.chevron_right,
                              color: Colors.black87,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                faq['question']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(52, 0, 16, 16),
                        child: Text(
                          faq['answer']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
