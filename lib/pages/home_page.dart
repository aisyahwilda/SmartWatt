import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartwatt_app/constants/colors_app.dart';
import 'package:smartwatt_app/providers/auth_provider.dart';
import 'package:smartwatt_app/database/db_provider.dart';
import 'package:smartwatt_app/database/app_database.dart';
import 'package:drift/drift.dart' show OrderingTerm, OrderingMode;
import 'package:smartwatt_app/widgets/app_bottom_nav.dart';
import 'package:smartwatt_app/services/gemini_service.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDevicesForUser());
  }

  Future<void> _loadDevicesForUser() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final db = DbProvider.instance;
    _loadingDevices = true;
    setState(() {});

    if (auth.user == null) {
      _devices = [];
      _totalDailyKWh = 0.0;
      _loadingDevices = false;
      setState(() {});
      return;
    }

    final userId = auth.user!.id;
    final devices = await db.devicesDao.getDevicesForUser(userId);
    _devices = devices;

    // Load budget
    final budgets =
        await (db.select(db.monthlyBudgets)
              ..where((b) => b.userId.equals(userId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .get();
    if (budgets.isNotEmpty) {
      _monthlyBudget = budgets.first.budget;
    }

    // Calculate today's total and yesterday's total
    double total = 0.0;
    double yesterday = 0.0;
    for (final d in devices) {
      total += (d.watt * d.hoursPerDay) / 1000.0;
      await _loadUsageHistoryForDevice(d.id);

      // Get yesterday's data if available
      final history = _deviceUsageData[d.id];
      if (history != null && history.length >= 2) {
        yesterday += history[history.length - 2];
      } else {
        yesterday += (d.watt * d.hoursPerDay) / 1000.0;
      }
    }
    _totalDailyKWh = total;
    _yesterdayKWh = yesterday;
    _loadingDevices = false;
    setState(() {});

    // Load AI recommendations after devices are loaded
    _loadAIRecommendations();
  }

  Future<void> _loadAIRecommendations() async {
    if (_devices.isEmpty) {
      setState(() {
        _aiRecommendations = [
          '📱 Tambahkan perangkat untuk mendapat rekomendasi AI',
          '💡 Mulai pantau penggunaan listrik harianmu',
          '🎯 Atur budget untuk kontrol biaya lebih baik',
        ];
      });
      return;
    }

    setState(() {
      _loadingRecommendations = true;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final db = DbProvider.instance;

      // Get user profile data
      User? user;
      if (auth.user != null) {
        user = await db.usersDao.getUserById(auth.user!.id);
      }

      final deviceData = _devices.map((d) {
        return {'name': d.name, 'watt': d.watt, 'hours': d.hoursPerDay};
      }).toList();

      final recommendations = await _geminiService.generateRecommendations(
        devices: deviceData,
        totalDailyKWh: _totalDailyKWh,
        monthlyBudget: _monthlyBudget,
        jenisHunian: user?.jenisHunian,
        jumlahPenghuni: user?.jumlahPenghuni,
        dayaListrik: user?.dayaListrik,
        golonganTarif: user?.golonganTarif,
        tarifPerKwh: user?.tarifPerKwh,
      );

      setState(() {
        _aiRecommendations = recommendations;
        _loadingRecommendations = false;
      });
    } catch (e) {
      print('Error loading recommendations: $e');
      setState(() {
        _aiRecommendations = [
          '💡 Matikan perangkat yang tidak digunakan',
          '❄️ Atur suhu AC di 24-26°C',
          '⏰ Gunakan timer untuk perangkat tertentu',
        ];
        _loadingRecommendations = false;
      });
    }
  }

  Future<void> _loadUsageHistoryForDevice(int deviceId) async {
    final db = DbProvider.instance;
    final query = (db.select(db.usageHistory)
      ..where((u) => u.deviceId.equals(deviceId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc),
      ]));
    final rows = await query.get();
    if (rows.isNotEmpty) {
      _deviceUsageData[deviceId] = rows.map((r) => r.kWhUsed).toList();
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
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.paleBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/hero.png',
              fit: BoxFit.cover,
              width: 44,
              height: 44,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi, Mark!',
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
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isWide) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: constraints.maxHeight - 16.0,
                        child: SingleChildScrollView(child: _leftColumn()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: constraints.maxHeight - 16.0,
                        child: SingleChildScrollView(child: _rightColumn()),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _leftColumn(),
                const SizedBox(height: 16),
                _rightColumn(),
              ],
            );
          },
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
                    if (_loadingRecommendations)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
                      // Estimate monthly cost: daily kWh × 30 days × price per kWh
                      final monthlyCost = (_totalDailyKWh * 30 * 1500).toInt();
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
                                ? Colors.orange
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
                                  ? Colors.red.shade700
                                  : percentage > 0.7
                                  ? Colors.orange.shade700
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
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
                Text(
                  _totalDailyKWh.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepTeal,
                    height: 1.0,
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
            if (_totalDailyKWh > _yesterdayKWh)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sedikit lebih tinggi dari penggunaan kemarin.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_totalDailyKWh < _yesterdayKWh)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_down,
                      color: Colors.green.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bagus! Lebih hemat dari kemarin.',
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
    // Calculate daily and monthly costs
    final dailyCost = (_totalDailyKWh * 1500).toInt();
    final monthlyCost = (_totalDailyKWh * 30 * 1500).toInt();
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

    // Calculate today's usage for each device (watt * hours/day / 1000)
    final usageData = devices.map((d) {
      final watt = d.watt;
      final hours = d.hoursPerDay;
      return watt * hours / 1000; // kWh
    }).toList();

    final maxVal = usageData.reduce((a, b) => a > b ? a : b);
    final count = devices.length;
    final double spacing = 10.0;
    final double barHeight = 28.0;
    final double nameWidth = size.width * 0.28;
    final double chartWidth = size.width - nameWidth - 80;

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
        text: TextSpan(
          text: devices[i].name.length > 10
              ? '${devices[i].name.substring(0, 10)}...'
              : devices[i].name,
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
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
