import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../database/app_database.dart';
import '../widgets/app_alert.dart';
import '../constants/colors_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoginSelected = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final pageContext = context;

    FocusScope.of(context).unfocus();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty) {
      await showAppAlert(
        context,
        title: 'Email kosong',
        message: 'Mohon masukkan email Anda.',
      );
      return;
    }

    // Validasi format email
    if (!email.contains('@') || !email.contains('.')) {
      await showAppAlert(
        context,
        title: 'Format email salah',
        message: 'Email harus menggunakan format: user@domain.com',
        icon: Icons.error_outline,
        color: Colors.orange,
      );
      return;
    }

    if (password.isEmpty) {
      await showAppAlert(
        context,
        title: 'Password kosong',
        message: 'Mohon masukkan password Anda.',
      );
      return;
    }

    try {
      final db = context.read<AppDatabase>();
      final existing = await db.usersDao.getUserByEmail(email);
      if (existing == null) {
        if (!mounted) return;
        await showAppAlert(
          pageContext,
          title: 'Akun tidak ditemukan',
          message: 'Email belum terdaftar.',
        );
        return;
      }

      final user = await auth.login(email, password);
      if (user == null) {
        if (!mounted) return;
        await showAppAlert(
          pageContext,
          title: 'Gagal masuk',
          message:
              'Email atau password salah. Periksa kembali kredensial Anda.',
        );
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(pageContext, '/home');
    } catch (e) {
      if (!mounted) return;
      await showAppAlert(
        context,
        title: 'Terjadi kesalahan',
        message: 'Coba lagi nanti.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              Text(
                'Mulai Perjalanan\nHemat Energimu!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk ke akun Anda',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.black80,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.teal50,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!_isLoginSelected) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isLoginSelected
                                ? AppColors.deepTeal
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              color: _isLoginSelected
                                  ? Colors.white
                                  : AppColors.deepTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_isLoginSelected) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/register',
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isLoginSelected
                                ? AppColors.deepTeal
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                              color: !_isLoginSelected
                                  ? Colors.white
                                  : AppColors.deepTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Email field
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email, color: AppColors.teal),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock, color: AppColors.teal),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.deepTeal,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(color: Color(0xFF494949)),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Hero(
                tag: 'login_btn',
                child: ElevatedButton(
                  onPressed: auth.loading ? null : () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: AppColors.deepTeal,
                    foregroundColor: Colors.white,
                  ),
                  child: auth.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Masuk', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 28),
              GestureDetector(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    children: [
                      const TextSpan(text: 'Belum punya akun? '),
                      TextSpan(
                        text: 'Daftar Sekarang',
                        style: TextStyle(
                          color: AppColors.deepTeal,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
