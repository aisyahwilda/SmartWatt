import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import '../providers/auth_provider.dart';
import '../constants/colors_app.dart';
import '../widgets/app_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String id = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _isLoginSelected = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _createAccount(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final pageContext = context;
    final navigator = Navigator.of(pageContext);
    FocusScope.of(context).unfocus();
    final email = _emailCtrl.text.trim();
    final pass = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (email.isEmpty) {
      await showAppAlert(
        context,
        title: 'Email kosong',
        message: 'Mohon masukkan alamat email Anda.',
        icon: Icons.mail_outline,
        color: AppColors.deepTeal,
      );
      return;
    }

    // Validasi format email (harus ada @ dan .)
    if (!email.contains('@') || !email.contains('.')) {
      await showAppAlert(
        context,
        title: 'Format email salah',
        message: 'Email harus menggunakan format: user@domain.com',
        icon: Icons.error_outline,
        color: Colors.red,
      );
      return;
    }

    if (pass.isEmpty) {
      await showAppAlert(
        context,
        title: 'Password kosong',
        message: 'Mohon masukkan password Anda (minimal 8 karakter).',
        icon: Icons.lock_outline,
        color: AppColors.deepTeal,
      );
      return;
    }

    if (confirm.isEmpty) {
      await showAppAlert(
        context,
        title: 'Konfirmasi password kosong',
        message: 'Mohon masukkan ulang password Anda pada kolom konfirmasi.',
        icon: Icons.lock_outline,
        color: AppColors.deepTeal,
      );
      return;
    }

    if (pass.length < 8) {
      await showAppAlert(
        context,
        title: 'Password terlalu pendek',
        message: 'Password harus memiliki minimal 8 karakter.',
        icon: Icons.lock_clock,
        color: Colors.red,
      );
      return;
    }

    if (pass != confirm) {
      await showAppAlert(
        context,
        title: 'Password tidak sama',
        message: 'Password dan konfirmasi tidak cocok. Coba lagi.',
        icon: Icons.error_outline,
        color: Colors.red,
      );
      return;
    }

    try {
      final ok = await auth.register(email, pass);
      if (ok) {
        if (!mounted) return;

        await showAppAlert(
          pageContext,
          title: 'Pendaftaran Berhasil!',
          message:
              'Akun Anda telah berhasil dibuat. Silakan login dengan akun yang telah didaftarkan.',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );

        if (!mounted) return;

        _emailCtrl.clear();
        _passwordCtrl.clear();
        _confirmCtrl.clear();

        navigator.pushReplacementNamed('/login');
      }
    } catch (e) {
      if (!mounted) return;
      await showAppAlert(
        pageContext,
        title: 'Gagal membuat akun',
        message: 'Terjadi kesalahan: ${e.toString()}',
        icon: Icons.error_outline,
        color: Colors.red,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Buat Akun',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.black90,
                    ),
                    children: [
                      const TextSpan(text: 'Sudah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: const TextStyle(
                          color: AppColors.deepTeal,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

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

              const SizedBox(height: 18),

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
                obscureText: _obscure1,
                autofillHints: const [AutofillHints.newPassword],
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
                      _obscure1 ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.deepTeal,
                    ),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _confirmCtrl,
                obscureText: _obscure2,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  hintText: 'Konfirmasi Password',
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
                      _obscure2 ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.deepTeal,
                    ),
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: auth.loading ? null : () => _createAccount(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.deepTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.deepTeal40,
                ),
                child: auth.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Buat Akun',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
