import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartwatt_app/constants/colors_app.dart';
import 'package:smartwatt_app/widgets/app_bottom_nav.dart';
import 'package:smartwatt_app/widgets/app_alert.dart';
import 'package:smartwatt_app/providers/auth_provider.dart';
import 'package:smartwatt_app/database/db_provider.dart';
import 'package:smartwatt_app/database/app_database.dart';

class DevicesPage extends StatefulWidget {
  static const String routeName = '/devices';

  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool _loading = true;
  List<Device> _devices = [];

  final List<String> _categories = [
    'Kulkas',
    'AC',
    'Mesin Cuci',
    'TV',
    'Lampu',
    'Laptop',
    'Lainnya',
  ];

  String? _imageFor(Device d) {
    final key = (d.name.isNotEmpty ? d.name : d.category).toLowerCase();
    const map = {
      'kulkas': 'images/kulkas.jpg',
      'lemari es': 'images/kulkas.jpg',
      'ac': 'images/ac.png',
      'pendingin': 'images/ac.png',
      'mesin cuci': 'images/mesin_cuci.jpg',
      'tv': 'images/tv.png',
      'televisi': 'images/tv.png',
      'lampu': 'images/lampu.jpg',
      'komputer': 'images/laptop.png',
      'laptop': 'images/laptop.png',
    };
    for (final entry in map.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    final cat = d.category.toLowerCase();
    for (final entry in map.entries) {
      if (cat.contains(entry.key)) return entry.value;
    }
    return null;
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
                    value: _categories.contains(categoryCtl.text)
                        ? categoryCtl.text
                        : _categories.last,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
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
                    decoration: const InputDecoration(labelText: 'Watt (Daya)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hoursCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jam penggunaan/hari',
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
                    final hours = int.tryParse(hoursCtl.text.trim()) ?? 0;
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
                    await DbProvider.instance.devicesDao.updateDevice(
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
                    await showAppAlert(
                      pageContext,
                      title: 'Tersimpan',
                      message: 'Perangkat berhasil diperbarui.',
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

    final devices = await DbProvider.instance.devicesDao.getDevicesForUser(
      auth.user!.id,
    );
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
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
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
                    decoration: const InputDecoration(labelText: 'Watt (Daya)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hoursCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jam penggunaan/hari',
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
                    final hours = int.tryParse(hoursCtl.text.trim()) ?? 0;
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

                    await DbProvider.instance.devicesDao.insertDevice(
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
                    await showAppAlert(
                      pageContext,
                      title: 'Berhasil',
                      message: 'Perangkat berhasil ditambahkan.',
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
        await DbProvider.instance.devicesDao.deleteDevice(d.id);
        await _loadDevices();
        if (!mounted) return;
        await showAppAlert(
          pageContext,
          title: 'Terhapus',
          message: 'Perangkat berhasil dihapus.',
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
        title: const Text('Daftar Perangkat'),
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
                      final imgPath = _imageFor(d);
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
                                  if (imgPath != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.asset(
                                        imgPath,
                                        width: 70,
                                        height: 82,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) =>
                                            const SizedBox(
                                              width: 70,
                                              height: 82,
                                            ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 70,
                                      height: 82,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.devices_other,
                                        size: 32,
                                        color: Colors.black45,
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
