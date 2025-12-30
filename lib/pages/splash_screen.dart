import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/colors_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Restore session dari secure storage
    await auth.restoreSession();

    // Tunggu minimal 1 detik untuk UX (splash screen effect)
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Cek apakah user sudah login
    if (auth.user != null) {
      // Ada session → langsung ke home
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Belum login → ke hero/onboarding page
      Navigator.of(context).pushReplacementNamed('/hero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo SmartWatt
            Image.asset(
              'images/logo_app.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.bolt, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'SmartWatt',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pantau Listrik, Hemat Biaya',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
