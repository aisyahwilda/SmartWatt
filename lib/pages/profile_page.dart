import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants/colors_app.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_alert.dart';
import '../database/app_database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _housingController = TextEditingController();
  final _memberCountController = TextEditingController();
  final _powerRatingController = TextEditingController();
  final _priceGroupController = TextEditingController();
  final _pricePerKwhController = TextEditingController();

  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userEmail = auth.user?.email ?? '';

    _emailController.text = userEmail;

    if (auth.user != null) {
      final db = context.read<AppDatabase>();
      final user = await db.usersDao.getUserById(auth.user!.id);

      if (user != null && mounted) {
        // Load fullName from database
        _nameController.text = user.fullName?.isNotEmpty == true
            ? user.fullName!
            : '';
        _housingController.text = user.jenisHunian ?? '';
        _memberCountController.text = user.jumlahPenghuni?.toString() ?? '';
        _powerRatingController.text = user.dayaListrik?.toString() ?? '';
        _priceGroupController.text = user.golonganTarif ?? '';
        _pricePerKwhController.text = user.tarifPerKwh?.toString() ?? '';
        setState(() {});
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _profileImage = image;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto berhasil dipilih'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      await showAppAlert(
        context,
        title: 'Error',
        message: 'Gagal memilih gambar: $e',
        icon: Icons.error_outline,
        color: Colors.red,
      );
    }
  }

  Future<void> _showSaveConfirmation() async {
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

      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if (auth.user == null) return;

        final db = context.read<AppDatabase>();

        final jumlahPenghuni = int.tryParse(_memberCountController.text.trim());
        final dayaListrik = int.tryParse(_powerRatingController.text.trim());
        final tarifPerKwh = double.tryParse(_pricePerKwhController.text.trim());

        await db.usersDao.updateUserProfile(
          userId: auth.user!.id,
          fullName: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : null,
          profilePhotePath: _profileImage != null ? _profileImage!.path : null,
          jenisHunian: _housingController.text.trim().isNotEmpty
              ? _housingController.text.trim()
              : null,
          jumlahPenghuni: jumlahPenghuni,
          dayaListrik: dayaListrik,
          golonganTarif: _priceGroupController.text.trim().isNotEmpty
              ? _priceGroupController.text.trim()
              : null,
          tarifPerKwh: tarifPerKwh,
        );

        // Update AuthProvider with latest user data
        final updatedUser = await db.usersDao.getUserById(auth.user!.id);
        if (updatedUser != null) {
          auth.setUser(updatedUser);
        }

        if (!mounted) return;
        await showAppAlert(
          context,
          title: 'Berhasil',
          message: 'Profil berhasil diperbarui.',
          icon: Icons.check_circle_outline,
          color: AppColors.deepTeal,
        );

        // Return true to indicate profile was updated
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } catch (e) {
        if (!mounted) return;
        await showAppAlert(
          context,
          title: 'Error',
          message: 'Gagal menyimpan profil: $e',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _housingController.dispose();
    _memberCountController.dispose();
    _powerRatingController.dispose();
    _priceGroupController.dispose();
    _pricePerKwhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthProvider>();

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
          'Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      width: 120,
                      height: 120,
                      color: AppColors.lightTeal,
                      child: _profileImage != null
                          ? (kIsWeb
                                ? Image.network(
                                    _profileImage!.path,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          _nameController.text.isNotEmpty
                                              ? _nameController.text[0]
                                                    .toUpperCase()
                                              : 'U',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.deepTeal,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.file(
                                    File(_profileImage!.path),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          _nameController.text.isNotEmpty
                                              ? _nameController.text[0]
                                                    .toUpperCase()
                                              : 'U',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.deepTeal,
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                          : Center(
                              child: Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepTeal,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.deepTeal,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _nameController.text.isNotEmpty ? _nameController.text : 'User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),

            _buildTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: 'Email',
              enabled: false,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _housingController,
              label: 'Jenis Hunian',
              hint: 'Rumah/Apartemen/Kos',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _memberCountController,
              label: 'Jumlah Penghuni',
              keyboardType: TextInputType.number,
              hint: 'Contoh: 4',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _powerRatingController,
              label: 'Daya Listrik (VA)',
              keyboardType: TextInputType.number,
              hint: 'Contoh: 1300',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _priceGroupController,
              label: 'Golongan Tarif',
              hint: 'Contoh: R-1/TR',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _pricePerKwhController,
              label: 'Tarif per kWh',
              keyboardType: TextInputType.number,
              hint: 'Contoh: 1500',
            ),

            const SizedBox(height: 32),

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

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    bool enabled = true,
    VoidCallback? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: (_) => onChanged?.call(),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        ),
        style: TextStyle(
          fontSize: 15,
          color: enabled ? Colors.black87 : Colors.grey.shade500,
        ),
      ),
    );
  }
}
