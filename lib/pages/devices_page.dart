import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors_app.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_alert.dart';
import '../providers/auth_provider.dart';
import '../database/app_database.dart';

class DevicesPage extends StatefulWidget {
  static const String routeName = '/devices';

  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool _loading = true;
  List<Device> _devices = [];

  // Kategori perangkat yang valid (17 kategori spesifik)
  static const List<String> _categories = [
    'Lampu',
    'AC',
    'Kipas Angin',
    'Speaker',
    'Rice Cooker',
    'Microwave',
    'Blender',
    'Kulkas',
    'Laptop',
    'PC',
    'Printer',
    'Monitor',
    'Mesin Cuci',
    'Setrika',
    'Pompa Air',
    'TV',
  ];

  // Helper: dapatkan icon untuk setiap kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Lampu':
        return Icons.lightbulb;
      case 'AC':
        return Icons.ac_unit;
      case 'Kipas Angin':
        return Icons.air;
      case 'Speaker':
        return Icons.speaker;
      case 'Rice Cooker':
        return Icons.rice_bowl;
      case 'Microwave':
        return Icons.microwave;
      case 'Blender':
        return Icons.blender;
      case 'Kulkas':
        return Icons.kitchen;
      case 'Laptop':
        return Icons.laptop;
      case 'PC':
        return Icons.computer;
      case 'Printer':
        return Icons.print;
      case 'Monitor':
        return Icons.monitor;
      case 'Mesin Cuci':
        return Icons.local_laundry_service;
      case 'Setrika':
        return Icons.iron;
      case 'Pompa Air':
        return Icons.water_drop;
      case 'TV':
        return Icons.tv;
      default:
        return Icons.devices;
    }
  }

  // Helper: dapatkan asset image berdasarkan kategori
  String _getDeviceImage(String category, String deviceName) {
    // Mapping langsung per kategori
    switch (category) {
      case 'Lampu':
        return 'images/lampu.png';
      case 'AC':
        return 'images/AC.png';
      case 'Kipas Angin':
        return 'images/kipas.png';
      case 'Speaker':
        return 'images/speaker.png';
      case 'Rice Cooker':
        return 'images/ricecooker.png';
      case 'Microwave':
        return 'images/microwave.png';
      case 'Blender':
        return 'images/blender.png';
      case 'Kulkas':
        return 'images/kulkas.png';
      case 'Laptop':
        return 'images/laptop.png';
      case 'PC':
        return 'images/pc.png';
      case 'Printer':
        return 'images/printer.png';
      case 'Monitor':
        return 'images/pc.png';
      case 'Mesin Cuci':
        return 'images/mesincuci.png';
      case 'Setrika':
        return 'images/setrika.png';
      case 'Pompa Air':
        return 'images/pompair.png';
      case 'TV':
        return 'images/TV.png';
      default:
        return 'images/hero.png';
    }
  }

  Future<void> _showEditDialog(Device device) async {
    final pageContext = context;
    final nameCtl = TextEditingController(text: device.name);
    final categoryCtl = TextEditingController(text: device.category);
    final wattCtl = TextEditingController(text: device.watt.toString());
    final hoursCtl = TextEditingController(text: device.hoursPerDay.toString());

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Edit Perangkat'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Perangkat',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _categories.contains(device.category)
                        ? device.category
                        : _categories.last,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Row(
                              children: [
                                Icon(_getCategoryIcon(cat), size: 20),
                                const SizedBox(width: 8),
                                Text(cat),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(
                      () => categoryCtl.text = val ?? _categories.last,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: wattCtl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      // sanitize input and alert if letters present
                      final cleaned = val.replaceAll(RegExp(r'[^0-9]'), '');
                      if (cleaned != val) {
                        wattCtl.text = cleaned;
                        wattCtl.selection = TextSelection.fromPosition(
                          TextPosition(offset: wattCtl.text.length),
                        );
                        showAppAlert(
                          context,
                          title: 'Input tidak valid',
                          message: 'Masukkan angka saja, jangan huruf.',
                          icon: Icons.error_outline,
                          color: Colors.orange,
                        );
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Watt (Daya)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hoursCtl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                    ],
                    onChanged: (val) {
                      // allow only digits and one dot
                      var cleaned = val.replaceAll(RegExp(r'[^0-9\.]'), '');
                      final dotCount = '.'.allMatches(cleaned).length;
                      if (dotCount > 1) {
                        // keep only first dot
                        final firstDotIndex = cleaned.indexOf('.');
                        cleaned = cleaned.replaceAll('.', '');
                        cleaned =
                            cleaned.substring(0, firstDotIndex) +
                            '.' +
                            cleaned.substring(firstDotIndex);
                      }
                      if (cleaned != val) {
                        hoursCtl.text = cleaned;
                        hoursCtl.selection = TextSelection.fromPosition(
                          TextPosition(offset: hoursCtl.text.length),
                        );
                        showAppAlert(
                          context,
                          title: 'Input tidak valid',
                          message:
                              'Masukkan angka saja (boleh menggunakan titik untuk desimal).',
                          icon: Icons.error_outline,
                          color: Colors.orange,
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Jam penggunaan/hari',
                      hintText: 'Contoh: 2.5',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final name = nameCtl.text.trim();
                    final category = categoryCtl.text.trim();
                    final watt = int.tryParse(wattCtl.text.trim()) ?? 0;
                    final hours = double.tryParse(hoursCtl.text.trim()) ?? 0.0;
                    if (name.isEmpty ||
                        category.isEmpty ||
                        watt <= 0 ||
                        hours <= 0) {
                      await showAppAlert(
                        context,
                        title: 'Input tidak valid',
                        message: 'Mohon isi semua field dengan benar.',
                      );
                      return;
                    }
                    if (hours > 24) {
                      await showAppAlert(
                        context,
                        title: 'Jam penggunaan tidak valid',
                        message:
                            'Jam penggunaan tidak boleh lebih dari 24 jam per hari.',
                        icon: Icons.access_time,
                        color: Colors.orange,
                      );
                      return;
                    }
                    // Single confirmation before saving changes
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text('Konfirmasi'),
                        content: const Text(
                          'Anda yakin ingin menyimpan perubahan?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Tidak'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Iya'),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;
                    final db = Provider.of<AppDatabase>(context, listen: false);
                    await db.devicesDao.updateDevice(
                      id: device.id,
                      name: name,
                      category: category,
                      watt: watt,
                      hoursPerDay: hours,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    await _loadDevices();
                    if (!mounted) return;
                    // Success feedback via snackbar (only one alert flow overall)
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.successGreen,
                        content: Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Perangkat berhasil diperbarui.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Simpan', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDevices());
  }

  Future<void> _loadDevices() async {
    setState(() => _loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null) {
      setState(() {
        _devices = [];
        _loading = false;
      });
      return;
    }

    final db = Provider.of<AppDatabase>(context, listen: false);
    final devices = await db.devicesDao.getDevicesForUser(auth.user!.id);
    setState(() {
      _devices = devices;
      _loading = false;
    });
  }

  Future<void> _showAddDialog() async {
    final pageContext = context;
    final nameCtl = TextEditingController();
    String selectedCategory = _categories.first;
    final wattCtl = TextEditingController();
    final hoursCtl = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Tambah Perangkat'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Perangkat',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _categories.contains(selectedCategory)
                        ? selectedCategory
                        : _categories.first,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Row(
                              children: [
                                Icon(_getCategoryIcon(cat), size: 20),
                                const SizedBox(width: 8),
                                Text(cat),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(
                      () => selectedCategory = val ?? _categories.first,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: wattCtl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      final cleaned = val.replaceAll(RegExp(r'[^0-9]'), '');
                      if (cleaned != val) {
                        wattCtl.text = cleaned;
                        wattCtl.selection = TextSelection.fromPosition(
                          TextPosition(offset: wattCtl.text.length),
                        );
                        showAppAlert(
                          context,
                          title: 'Input tidak valid',
                          message: 'Masukkan angka saja, jangan huruf.',
                          icon: Icons.error_outline,
                          color: Colors.orange,
                        );
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Watt (Daya)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hoursCtl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                    ],
                    onChanged: (val) {
                      var cleaned = val.replaceAll(RegExp(r'[^0-9\.]'), '');
                      final dotCount = '.'.allMatches(cleaned).length;
                      if (dotCount > 1) {
                        final firstDotIndex = cleaned.indexOf('.');
                        cleaned = cleaned.replaceAll('.', '');
                        cleaned =
                            cleaned.substring(0, firstDotIndex) +
                            '.' +
                            cleaned.substring(firstDotIndex);
                      }
                      if (cleaned != val) {
                        hoursCtl.text = cleaned;
                        hoursCtl.selection = TextSelection.fromPosition(
                          TextPosition(offset: hoursCtl.text.length),
                        );
                        showAppAlert(
                          context,
                          title: 'Input tidak valid',
                          message:
                              'Masukkan angka saja (boleh menggunakan titik untuk desimal).',
                          icon: Icons.error_outline,
                          color: Colors.orange,
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Jam penggunaan/hari',
                      hintText: 'Contoh: 2.5',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final name = nameCtl.text.trim();
                    final category = selectedCategory;
                    final watt = int.tryParse(wattCtl.text.trim()) ?? 0;
                    final hours = double.tryParse(hoursCtl.text.trim()) ?? 0.0;
                    if (name.isEmpty || watt <= 0 || hours <= 0) {
                      await showAppAlert(
                        dialogContext,
                        title: 'Input tidak valid',
                        message: 'Mohon isi semua field dengan benar.',
                      );
                      return;
                    }
                    if (hours > 24) {
                      await showAppAlert(
                        dialogContext,
                        title: 'Jam penggunaan tidak valid',
                        message:
                            'Jam penggunaan tidak boleh lebih dari 24 jam per hari.',
                        icon: Icons.access_time,
                        color: Colors.orange,
                      );
                      return;
                    }
                    // Single confirmation before adding device
                    final confirm = await showDialog<bool>(
                      context: dialogContext,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text('Konfirmasi'),
                        content: const Text(
                          'Anda yakin ingin menyimpan perangkat?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Tidak'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Iya'),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;

                    final auth = Provider.of<AuthProvider>(
                      dialogContext,
                      listen: false,
                    );
                    if (auth.user == null) {
                      Navigator.of(dialogContext).pop();
                      if (!mounted) return;
                      await showAppAlert(
                        pageContext,
                        title: 'Sesi berakhir',
                        message: 'Silakan login kembali.',
                      );
                      return;
                    }

                    final db = Provider.of<AppDatabase>(
                      dialogContext,
                      listen: false,
                    );
                    await db.devicesDao.insertDevice(
                      userId: auth.user!.id,
                      name: name,
                      category: category,
                      watt: watt,
                      hoursPerDay: hours,
                    );

                    if (!mounted) return;
                    Navigator.of(dialogContext).pop();
                    await _loadDevices();
                    if (!mounted) return;
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.successGreen,
                        content: Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Perangkat berhasil ditambahkan.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Simpan', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAndDelete(Device d) async {
    final pageContext = context;
    final confirm = await showDialog<bool>(
      context: pageContext,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Hapus perangkat'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus perangkat ini?',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus', style: TextStyle(fontSize: 14)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final db = Provider.of<AppDatabase>(context, listen: false);
        await db.devicesDao.deleteDevice(d.id);
        await _loadDevices();
        if (!mounted) return;
        ScaffoldMessenger.of(pageContext).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.successGreen,
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Perangkat berhasil dihapus.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        await showAppAlert(
          pageContext,
          title: 'Gagal',
          message: 'Terjadi kesalahan saat menghapus perangkat.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: const Text(
          'Daftar Perangkat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: _showAddDialog, icon: const Icon(Icons.add)),
        ],
      ),
      backgroundColor: AppColors.paleBlue,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _devices.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Belum ada perangkat.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _showAddDialog,
                      child: const Text('Tambah Perangkat'),
                    ),
                  ],
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final cross = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: cross,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.15,
                    children: _devices.map((d) {
                      final daily = (d.watt * d.hoursPerDay) / 1000.0;
                      final imgPath = _getDeviceImage(d.category, d.name);
                      return Card(
                        color: AppColors.lightTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showEditDialog(d),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () => _confirmAndDelete(d),
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: AppColors.deepTeal,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 1),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.asset(
                                      imgPath,
                                      width: 70,
                                      height: 82,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        width: 70,
                                        height: 82,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Icon(
                                          _getCategoryIcon(d.category),
                                          size: 32,
                                          color: AppColors.deepTeal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Perangkat',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          d.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: AppColors.deepTeal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${d.watt} Watt',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${d.hoursPerDay} Jam/hari',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                'Konsumsi: ${daily.toStringAsFixed(2)} kWh/hari',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 1),
    );
  }
}
