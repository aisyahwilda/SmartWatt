import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartwatt_app/constants/colors_app.dart';
import 'package:smartwatt_app/widgets/app_alert.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _budgetController = TextEditingController();
  int? _selectedQuickBudget;

  final List<int> _quickBudgets = [
    50000,
    100000,
    150000,
    200000,
    250000,
    300000,
    400000,
    500000,
  ];

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _selectQuickBudget(int amount) {
    setState(() {
      _selectedQuickBudget = amount;
      _budgetController.text = amount.toString();
    });
  }

  Future<void> _showSaveConfirmation() async {
    final budgetText = _budgetController.text.trim();

    if (budgetText.isEmpty) {
      await showAppAlert(
        context,
        title: 'Input tidak valid',
        message: 'Mohon masukkan jumlah budget.',
        icon: Icons.error_outline,
        color: Colors.orange,
      );
      return;
    }

    final budget = int.tryParse(budgetText);
    if (budget == null || budget <= 0) {
      await showAppAlert(
        context,
        title: 'Input tidak valid',
        message: 'Mohon masukkan angka budget dalam rupiah yang valid.',
        icon: Icons.error_outline,
        color: Colors.orange,
      );
      return;
    }

    if (budget < 10000) {
      await showAppAlert(
        context,
        title: 'Budget terlalu kecil',
        message: 'Budget minimal adalah Rp 10.000.',
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Anda yakin ingin menyimpan perubahan?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Iya', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result == true) {
      if (!mounted) return;
      // TODO: Save budget to database
      await showAppAlert(
        context,
        title: 'Berhasil',
        message: 'Budget listrik bulanan berhasil disimpan.',
        icon: Icons.check_circle_outline,
        color: AppColors.deepTeal,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

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
          'Budget Listrik',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            const Text(
              'Berapa budget listrik bulanan Anda?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Masukkan jumlah budget listrik yang ingin kamu tetapkan. SmartWatt akan memberi peringatan jika pemakaian mendekati batas.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Section Title
            const Text(
              'Budget Listrik Bulanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Masukkan Budget Section
            const Text(
              'Masukkan Budget',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // Quick Budget Selection
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickBudgets.length,
                itemBuilder: (context, index) {
                  final amount = _quickBudgets[index];
                  final isSelected = _selectedQuickBudget == amount;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppColors.deepTeal
                            : AppColors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: isSelected ? 4 : 2,
                      ),
                      onPressed: () => _selectQuickBudget(amount),
                      child: Text(
                        'Rp. ${amount ~/ 1000}.000',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Manual Input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Budget (Rp)',
                  hintText: 'Contoh: 200000',
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Text(
                      'Rp',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepTeal,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  // Clear selection when manually typing
                  if (_selectedQuickBudget != null) {
                    setState(() {
                      _selectedQuickBudget = null;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Masukkan budget dalam rupiah (tanpa titik atau koma)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showSaveConfirmation,
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
