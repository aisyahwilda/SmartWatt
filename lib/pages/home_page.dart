import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors_app.dart';
import '../providers/auth_provider.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart' show OrderingTerm, OrderingMode;
import '../widgets/app_bottom_nav.dart';
import '../services/gemini_service.dart';
import 'budget_page.dart';

class SmartWattDashboard extends StatefulWidget {
  const SmartWattDashboard({super.key});

  @override
  State<SmartWattDashboard> createState() => _SmartWattDashboardState();
}

class _SmartWattDashboardState extends State<SmartWattDashboard> {
  int _selectedDeviceIndex = 0;
  List<Device> _devices = [];
  final Map<int, List<double>> _deviceUsageData = {};
  double _totalDailyKWh = 0.0;
  double _yesterdayKWh = 0.0;
  int? _monthlyBudget;
  bool _loadingDevices = true;
  List<String> _aiRecommendations = [];
  bool _loadingRecommendations = false;
  final GeminiService _geminiService = GeminiService();
  int _tarifPerKWh = 1500; // Default tarif listrik per kWh

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDevicesForUser());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload when returning to this page
    _loadDevicesForUser();
  }

  @override
  void didUpdateWidget(covariant SmartWattDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadDevicesForUser();
  }

  Future<void> _loadDevicesForUser() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final db = Provider.of<AppDatabase>(context, listen: false);
    _loadingDevices = true;
    setState(() {});

    if (auth.user == null) {
      debugPrint('⚠️ [SmartWatt] User belum login, tidak ada data device');
      _devices = [];
      _totalDailyKWh = 0.0;
      _monthlyBudget = null;
      _loadingDevices = false;
      setState(() {});
      return;
    }

    final userId = auth.user!.id;
    debugPrint('✅ [SmartWatt] Loading devices untuk user ID: $userId');

    // Load user profile for name, email, and tarif
    final user = await db.usersDao.getUserById(userId);
    if (user != null) {
      debugPrint('✅ [SmartWatt] User loaded: ${user.fullName ?? user.email}');
      // Ambil tarif dari user, jika null pakai default 1500
      _tarifPerKWh = user.tarifPerKwh?.toInt() ?? 1500;
      print('✅ [SmartWatt] Tarif: Rp $_tarifPerKWh/kWh');
      setState(() {}); // Update UI immediately after loading user profile
    }

    final devices = await db.devicesDao.getDevicesForUser(userId);
    _devices = devices;
    debugPrint('✅ [SmartWatt] Devices loaded: ${devices.length} perangkat');

    // Load budget untuk bulan ini

    final budgets =
        await (db.select(db.monthlyBudgets)
              ..where((b) => b.userId.equals(userId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
              ..limit(1))
            .get();

    if (budgets.isNotEmpty) {
      final budget = budgets.first;
      final now = DateTime.now();

      // Check if budget is from current month
      if (budget.createdAt.year == now.year &&
          budget.createdAt.month == now.month) {
        _monthlyBudget = budget.budget;
      } else {
        _monthlyBudget = null;
      }
    } else {
      _monthlyBudget = null;
    }

    double total = 0.0;
    double yesterday = 0.0;
    for (final d in devices) {
      total += (d.watt * d.hoursPerDay) / 1000.0;
      await _loadUsageHistoryForDevice(d.id);

      final history = _deviceUsageData[d.id];
      if (history != null && history.length >= 2) {
        yesterday += history[history.length - 2];
      } else {
        yesterday += (d.watt * d.hoursPerDay) / 1000.0;
      }
    }
    _totalDailyKWh = total;
    _yesterdayKWh = yesterday;
    debugPrint(
      '✅ [SmartWatt] Total daily: ${_totalDailyKWh.toStringAsFixed(2)} kWh',
    );
    debugPrint('✅ [SmartWatt] Budget: ${_monthlyBudget ?? "Belum diatur"}');
    _loadingDevices = false;
    setState(() {});

    // Panggil AI hanya jika ada perangkat
    if (_devices.isNotEmpty) {
      debugPrint(
        '🤖 [SmartWatt] Memanggil AI untuk ${_devices.length} perangkat...',
      );
      _loadAIRecommendations();
    } else {
      print('⚠️ [SmartWatt] Tidak ada perangkat, skip AI recommendations');
    }
  }

  Future<void> _loadAIRecommendations() async {
    if (_devices.isEmpty) {
      debugPrint(
        'ℹ️ [SmartWatt] Devices kosong, tampilkan fallback recommendations',
      );
      setState(() {
        _aiRecommendations = [
          '📱 Tambahkan perangkat untuk mendapat rekomendasi AI',
          '💡 Mulai pantau penggunaan listrik harianmu',
          '🎯 Atur budget untuk kontrol biaya lebih baik',
        ];
        _loadingRecommendations = false;
      });
      return;
    }

    setState(() {
      _loadingRecommendations = true;
      _aiRecommendations = ['⏳ Meminta rekomendasi dari AI...'];
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final db = Provider.of<AppDatabase>(context, listen: false);

      User? user;
      if (auth.user != null) {
        user = await db.usersDao.getUserById(auth.user!.id);
      }

      final deviceData = _devices.map((d) {
        return {'name': d.name, 'watt': d.watt, 'hours': d.hoursPerDay};
      }).toList();

      debugPrint(
        '🤖 [SmartWatt] Calling Gemini API dengan ${deviceData.length} devices...',
      );
      debugPrint('   Total kWh: ${_totalDailyKWh.toStringAsFixed(2)}');
      debugPrint('   Budget: ${_monthlyBudget ?? "null"}');

      // Determine if over budget (use user's tarif)
      final monthlyCost = (_totalDailyKWh * 30 * _tarifPerKWh).toInt();
      final overBudget =
          _monthlyBudget != null && monthlyCost > _monthlyBudget!;

      // Find the device with highest consumption (most wasteful)
      Device mostWasteful = _devices.first;
      double maxConsumption = 0.0;
      for (final device in _devices) {
        final consumption = (device.watt * device.hoursPerDay) / 1000.0;
        if (consumption > maxConsumption) {
          maxConsumption = consumption;
          mostWasteful = device;
        }
      }

      final recommendations = await _geminiService.generateRecommendations(
        statusKonsumsi: overBudget ? 'OVER_BUDGET' : 'AMAN',
        perangkatBoros: mostWasteful.name,
        jenisHunian: user?.jenisHunian ?? '-',
        jumlahPenghuni: user?.jumlahPenghuni ?? 1,
      );

      print(
        '✅ [SmartWatt] AI returned ${recommendations.length} recommendations',
      );

      // Validate recommendations are not empty
      if (recommendations.isEmpty) {
        debugPrint(
          '⚠️ [SmartWatt] Recommendations list is empty, using fallback',
        );
        setState(() {
          _aiRecommendations = [
            '💡 AI berhasil dijalankan tapi tidak ada output',
            '🔄 Coba muat ulang rekomendasi dengan refresh',
          ];
          _loadingRecommendations = false;
        });
        return;
      }

      debugPrint(
        '🎯 [SmartWatt] Setting UI with ${recommendations.length} items',
      );
      setState(() {
        _aiRecommendations = recommendations;
        _loadingRecommendations = false;
      });
      debugPrint('✅ [SmartWatt] UI updated successfully');
    } catch (e, stack) {
      debugPrint('❌ [SmartWatt] Error calling AI: $e');
      debugPrint(
        '📋 Stack: ${stack.toString().split('\n').take(5).join('\n')}',
      );
      setState(() {
        _aiRecommendations = [
          '⚠️ Gagal memuat rekomendasi AI',
          '💡 Pastikan koneksi internet Anda stabil',
          '🔄 Coba refresh halaman ini',
          '',
          'Error: ${e.toString().substring(0, 100)}',
        ];
        _loadingRecommendations = false;
      });
    }
  }

  Future<void> _loadUsageHistoryForDevice(int deviceId) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    // Ambil 7 hari terakhir (order DESC, lalu dibalik agar urut kronologis)
    final query =
        (db.select(db.usageHistory)
              ..where((u) => u.deviceId.equals(deviceId))
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.date, mode: OrderingMode.desc),
              ])
              ..limit(7))
            .get();

    final rows = await query;
    if (rows.isNotEmpty) {
      final ordered = rows.reversed.map((r) => r.kWhUsed).toList();
      _deviceUsageData[deviceId] = ordered;
    }
  }

  List<double> _usageDataForDevice(Device d) {
    final data = _deviceUsageData[d.id];
    if (data != null && data.isNotEmpty) return data;
    final daily = (d.watt * d.hoursPerDay) / 1000.0;
    return List.generate(7, (_) => double.parse(daily.toStringAsFixed(2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.cover,
              width: 56,
              height: 56,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightTeal,
                  child: Icon(
                    Icons.energy_savings_leaf,
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
          ),
        ),
        title: Builder(
          builder: (context) {
            final auth = context.watch<AuthProvider>();
            final db = context.watch<AppDatabase>();

            if (auth.user == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, User!',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pantau dan hemat penggunaan listrik Anda dengan AI.',
                    style: TextStyle(color: AppColors.textDark80, fontSize: 12),
                  ),
                ],
              );
            }

            return StreamBuilder<User?>(
              stream: db.usersDao.watchUserById(auth.user!.id),
              builder: (context, snapshot) {
                String displayName = 'User';

                if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  if (user.fullName != null &&
                      user.fullName!.trim().isNotEmpty) {
                    // Tampilkan nama lengkap
                    displayName = user.fullName!;
                  } else {
                    // Fallback ke email username
                    displayName = user.email.split('@')[0];
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi, $displayName!',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pantau dan hemat penggunaan listrik Anda dengan AI.',
                      style: TextStyle(
                        color: AppColors.textDark80,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [_leftColumn(), const SizedBox(height: 16), _rightColumn()],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 0),
    );
  }

  Widget _leftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _usageCard()),
              const SizedBox(width: 12),
              Expanded(child: _estCostCard()),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (_devices.isEmpty && !_loadingDevices)
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belum ada perangkat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepTeal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan perangkat listrik rumahmu agar SmartWatt bisa menampilkan grafik pemakaian dan estimasi biaya.',
                    style: TextStyle(fontSize: 12, color: AppColors.textDark80),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/devices'),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Perangkat'),
                    ),
                  ),
                ],
              ),
            ),
          ),

        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pemakaian Listrik 7 Hari Terakhir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: _loadingDevices
                      ? const Center(child: CircularProgressIndicator())
                      : (_devices.isEmpty)
                      ? const Center(
                          child: Text(
                            'Belum ada perangkat. Tambah perangkat untuk melihat grafik.',
                          ),
                        )
                      : LineChart(
                          data: _usageDataForDevice(
                            _devices[_selectedDeviceIndex],
                          ),
                          color: AppColors.teal,
                          deviceName: _devices[_selectedDeviceIndex].name,
                        ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Pemakaian Perangkat Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Container(
                  height: _devices.isEmpty
                      ? 100
                      : (_devices.length * 45.0 + 24).clamp(
                          100,
                          double.infinity,
                        ),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: _loadingDevices
                      ? const Center(child: CircularProgressIndicator())
                      : (_devices.isEmpty)
                      ? const Center(
                          child: Text('Belum ada perangkat untuk ditampilkan.'),
                        )
                      : DeviceTodayBarChart(
                          devices: _devices,
                          color: AppColors.teal,
                        ),
                ),

                const SizedBox(height: 16),
                const Divider(),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Perangkat',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/devices'),
                      child: const Text('Lihat selengkapnya'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                _deviceList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rightColumn() {
    return Column(
      children: [
        // AI recommendation
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rekomendasi Penghematan AI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        if (_loadingRecommendations)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: _loadAIRecommendations,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Muat ulang rekomendasi',
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (_aiRecommendations.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Memuat rekomendasi...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...(_aiRecommendations.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4, right: 8),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.deepTeal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Budget
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Listrik Bulanan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (_monthlyBudget != null) ...[
                  Text('Budget: Rp ${_monthlyBudget! ~/ 1000}.000'),
                  const SizedBox(height: 6),
                  Builder(
                    builder: (context) {
                      // Estimate monthly cost: daily kWh × 30 days × user's tarif
                      final monthlyCost = (_totalDailyKWh * 30 * _tarifPerKWh)
                          .toInt();
                      final percentage = _monthlyBudget! > 0
                          ? (monthlyCost / _monthlyBudget!).clamp(0.0, 1.0)
                          : 0.0;
                      final percentageText = (percentage * 100).toStringAsFixed(
                        0,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimasi bulan ini: Rp ${monthlyCost ~/ 1000}.000 ($percentageText%)',
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: AppColors.lightTeal,
                            color: percentage > 0.8
                                ? Colors.red
                                : percentage > 0.6
                                ? Colors.red
                                : AppColors.teal,
                            minHeight: 12,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            percentage > 0.9
                                ? 'Perhatian! Budget hampir habis!'
                                : percentage > 0.7
                                ? 'Budget mulai tinggi, pertimbangkan untuk hemat.'
                                : 'Masih aman, pertahankan pola hematmu!',
                            style: TextStyle(
                              fontSize: 12,
                              color: percentage > 0.9
                                  ? Colors.yellow.shade700
                                  : percentage > 0.7
                                  ? Colors.yellow.shade700
                                  : Colors.grey.shade700,
                              fontWeight: percentage > 0.7
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ] else ...[
                  Text(
                    'Budget belum diatur',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      // Navigate ke budget page dan tunggu result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BudgetPage(),
                        ),
                      );

                      // Jika budget disimpan, reload data
                      if (result == true && mounted) {
                        await _loadDevicesForUser();
                      }
                    },
                    child: const Text('Atur Budget'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Profile card removed — profile will have its own page
      ],
    );
  }

  Widget _usageCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Penggunaan Hari Ini',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Angka besar dengan KWH
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    _totalDailyKWh.toStringAsFixed(2),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepTeal,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'KWH',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Warning message - dynamic based on data
            if (_yesterdayKWh > 0) ...[
              if (_totalDailyKWh > _yesterdayKWh) ...[
                () {
                  final percentageIncrease =
                      ((_totalDailyKWh - _yesterdayKWh) / _yesterdayKWh * 100);
                  final isSignificant = percentageIncrease > 20;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSignificant
                          ? Colors.red.shade50
                          : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSignificant
                            ? Colors.red.shade200
                            : Colors.amber.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSignificant
                              ? Icons.error_outline
                              : Icons.warning_amber_rounded,
                          color: isSignificant
                              ? Colors.red.shade700
                              : Colors.amber.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSignificant
                                    ? '⚠️ Penggunaan meningkat signifikan!'
                                    : 'Penggunaan lebih tinggi dari kemarin',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSignificant
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: isSignificant
                                      ? Colors.red.shade900
                                      : Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '+${percentageIncrease.toStringAsFixed(1)}% dari kemarin (${_yesterdayKWh.toStringAsFixed(2)} kWh)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }(),
              ] else if (_totalDailyKWh < _yesterdayKWh) ...[
                () {
                  final percentageDecrease =
                      ((_yesterdayKWh - _totalDailyKWh) / _yesterdayKWh * 100);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_down,
                          color: Colors.green.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✅ Hebat! Penggunaan lebih hemat',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '-${percentageDecrease.toStringAsFixed(1)}% dari kemarin (${_yesterdayKWh.toStringAsFixed(2)} kWh)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }(),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Penggunaan sama dengan kemarin (${_yesterdayKWh.toStringAsFixed(2)} kWh)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  double _computeWeeklyAverage() {
    if (_devices.isEmpty) return 0.0;

    // Calculate average from all devices' history
    double totalSum = 0.0;
    int totalDays = 0;

    for (final device in _devices) {
      final data = _deviceUsageData[device.id];
      if (data != null && data.isNotEmpty) {
        totalSum += data.reduce((a, b) => a + b);
        totalDays = data.length; // Assuming all devices have same days
      }
    }

    if (totalDays > 0) {
      return totalSum / totalDays;
    }

    return _totalDailyKWh;
  }

  Widget _estCostCard() {
    // Calculate daily and monthly costs using user's tarif
    final dailyCost = (_totalDailyKWh * _tarifPerKWh).toInt();
    final monthlyCost = (_totalDailyKWh * 30 * _tarifPerKWh).toInt();
    final weeklyAverage = _computeWeeklyAverage();

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perkiraan Biaya',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Daily cost
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.today, color: AppColors.deepTeal, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hari Ini',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${dailyCost ~/ 1000}.${(dailyCost % 1000).toString().padLeft(3, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 16),

            // Monthly estimate
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_month,
                    color: AppColors.deepTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimasi Bulan Ini',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${monthlyCost ~/ 1000}.${(monthlyCost % 1000).toString().padLeft(3, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 16),

            // Weekly average
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: AppColors.deepTeal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rata-rata Minggu Ini',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${weeklyAverage.toStringAsFixed(1)} kWh/hari',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceList() {
    if (_loadingDevices) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_devices.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Belum ada perangkat. Tambah perangkat untuk mulai memantau.',
          ),
        ),
      );
    }

    return Column(
      children: List.generate(_devices.length, (i) {
        final d = _devices[i];
        final selected = i == _selectedDeviceIndex;
        final daily = (d.watt * d.hoursPerDay) / 1000.0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.lightTeal : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.deepTeal : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.deepTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.devices, color: AppColors.deepTeal, size: 24),
            ),
            title: Text(
              d.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${d.watt} Watt · ${d.hoursPerDay} Jam/hari',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${daily.toStringAsFixed(2)} kWh/hari',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepTeal,
                  ),
                ),
              ],
            ),
            onTap: () async {
              setState(() => _selectedDeviceIndex = i);
              if (!_deviceUsageData.containsKey(d.id)) {
                await _loadUsageHistoryForDevice(d.id);
                setState(() {});
              }
            },
          ),
        );
      }),
    );
  }
}

class DeviceChart extends StatelessWidget {
  final List<double> data;
  final Color color;

  const DeviceChart({super.key, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _DeviceChartPainter(data: data, barColor: color),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            data.length > 7 ? 7 : data.length,
            (i) => Expanded(
              child: Text(
                i < days.length ? days[i] : '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceChartPainter extends CustomPainter {
  final List<double> data;
  final Color barColor;

  _DeviceChartPainter({required this.data, required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final int count = data.length > 7 ? 7 : data.length;
    final double spacing = 8.0;
    final double availableWidth = size.width - (spacing * (count + 1));
    final double barWidth = availableWidth / count;

    // Draw bars
    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    // Draw 3 horizontal grid lines
    for (int i = 1; i <= 3; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw bars with values on top
    for (int i = 0; i < count; i++) {
      final x = spacing + i * (barWidth + spacing);
      final value = data[i];
      final h = maxVal > 0 ? (value / maxVal) * (size.height - 20) : 0.0;
      final rect = Rect.fromLTWH(x, size.height - h, barWidth, h);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
      canvas.drawRRect(rrect, barPaint);

      // Draw value text on top of bar
      if (h > 15) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: value.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, size.height - h + 4),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeviceChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.barColor != barColor;
  }
}

// Line Chart Widget
class LineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final String deviceName;

  const LineChart({
    super.key,
    required this.data,
    required this.color,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          deviceName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.deepTeal,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _LineChartPainter(data: data, lineColor: color),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            data.length > 7 ? 7 : data.length,
            (i) => Expanded(
              child: Text(
                i < days.length ? days[i] : '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  _LineChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final int count = data.length > 7 ? 7 : data.length;
    final double spacing = size.width / (count - 1);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw gradient fill under line
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < count; i++) {
      final x = i * spacing;
      final value = data[i];
      final y = maxVal > 0
          ? size.height - (value / maxVal) * size.height
          : size.height;
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, size.height);
      path.lineTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      path.lineTo(points.last.dx, size.height);
      path.close();

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.3),
            lineColor.withValues(alpha: 0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(path, gradientPaint);
    }

    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path();
    if (points.isNotEmpty) {
      linePath.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(linePath, linePaint);
    }

    // Draw points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final whiteBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, whiteBorderPaint);
      canvas.drawCircle(point, 3.5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}

// Today's Device Usage Bar Chart
class DeviceTodayBarChart extends StatelessWidget {
  final List<Device> devices;
  final Color color;

  const DeviceTodayBarChart({
    super.key,
    required this.devices,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _TodayBarChartPainter(devices: devices, barColor: color),
        );
      },
    );
  }
}

class _TodayBarChartPainter extends CustomPainter {
  final List<Device> devices;
  final Color barColor;

  _TodayBarChartPainter({required this.devices, required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (devices.isEmpty) return;

    final usageData = devices.map((d) {
      final watt = d.watt;
      final hours = d.hoursPerDay;
      return watt * hours / 1000; // kWh
    }).toList();

    final maxVal = usageData.reduce((a, b) => a > b ? a : b);
    final count = devices.length;
    final double spacing = 10.0;
    final double barHeight = 28.0;
    final double nameWidth = size.width * 0.35;
    final double chartWidth = size.width - nameWidth - 70;

    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    final valueStyle = TextStyle(
      color: barColor,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );

    for (int i = 0; i < count; i++) {
      final y = i * (barHeight + spacing);

      // Draw device name
      final namePainter = TextPainter(
        text: TextSpan(text: devices[i].name, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      );
      namePainter.layout(maxWidth: nameWidth);
      namePainter.paint(
        canvas,
        Offset(0, y + (barHeight - namePainter.height) / 2),
      );

      // Draw bar
      final value = usageData[i];
      final barWidth = maxVal > 0 ? (value / maxVal) * chartWidth : 0.0;
      final barX = nameWidth + 8;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, y + 2, barWidth, barHeight - 4),
        const Radius.circular(6),
      );
      canvas.drawRRect(rect, barPaint);

      // Draw value
      final valuePainter = TextPainter(
        text: TextSpan(
          text: '${value.toStringAsFixed(1)} kWh',
          style: valueStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      valuePainter.paint(
        canvas,
        Offset(barX + barWidth + 6, y + (barHeight - valuePainter.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TodayBarChartPainter oldDelegate) {
    return oldDelegate.devices != devices || oldDelegate.barColor != barColor;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmartWattDashboard();
  }
}
