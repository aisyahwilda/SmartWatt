import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors_app.dart';
import '../widgets/app_bottom_nav.dart';
import '../providers/auth_provider.dart';
import '../database/app_database.dart';
import 'profile_page.dart';
import 'faq_page.dart';
import 'budget_page.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.paleBlue,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Builder(
              builder: (context) {
                if (auth.user == null) {
                  final email = 'user@example.com';
                  final name = 'User';
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.lightTeal,
                        child: Text(
                          name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hai User!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return StreamBuilder<User?>(
                  stream: db.usersDao.watchUserById(auth.user!.id),
                  builder: (context, snapshot) {
                    final email = auth.user!.email;
                    String displayName = email.split('@')[0];
                    String? photoPath;
                    if (snapshot.hasData && snapshot.data != null) {
                      final user = snapshot.data!;
                      if (user.fullName != null &&
                          user.fullName!.trim().isNotEmpty) {
                        displayName = user.fullName!;
                      }
                      photoPath = user.profilePhotePath;
                    }

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.lightTeal,
                          backgroundImage: photoPath != null
                              ? (kIsWeb
                                    ? NetworkImage(photoPath)
                                    : FileImage(File(photoPath)))
                              : null,
                          child: photoPath == null
                              ? Text(
                                  displayName.isNotEmpty
                                      ? displayName[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepTeal,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hai ${displayName.isNotEmpty ? displayName[0].toUpperCase() + displayName.substring(1) : "User"}!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          _buildSettingItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );

              // Jika profil diperbarui, tetap di halaman Pengaturan dan refresh tampilan
              if (result == true && mounted) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 12),

          _buildSettingItem(
            icon: Icons.help_outline,
            title: 'FAQs',
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const FaqPage()));
            },
          ),

          const SizedBox(height: 12),

          _buildSettingItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Budget Listrik',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BudgetPage()),
              );
            },
          ),

          const SizedBox(height: 12),

          _buildNotificationToggle(),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text('Konfirmasi Keluar'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Tidak'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Iya'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await auth.logout();
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text(
              'Keluar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 2),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightTeal,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.deepTeal, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotificationToggle() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final db = Provider.of<AppDatabase>(context, listen: false);

    if (auth.user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<User?>(
      stream: db.usersDao.watchUserById(auth.user!.id),
      builder: (context, snapshot) {
        final notificationsEnabled =
            snapshot.data?.notificationsEnabled ?? true;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.deepTeal,
                    size: 22,
                  ),
                ),
                title: const Text(
                  'Notifikasi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) async {
                    await db.usersDao.updateNotificationsEnabled(
                      auth.user!.id,
                      value,
                    );
                  },
                  activeThumbColor: AppColors.deepTeal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    notificationsEnabled
                        ? 'Notifikasi akan muncul saat membuka aplikasi'
                        : 'Notifikasi dimatikan',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
