/// Konfigurasi global aplikasi SmartWatt
class AppConfig {
  // API Configuration
  static const String geminiModel = 'gemini-1.5-flash'; // Free tier, 15 RPM
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiMaxRetries = 3;
  static const Duration apiRetryDelay = Duration(seconds: 2);

  // Budget Configuration
  static const int minBudget = 10000; // Rp 10.000
  static const int maxBudget = 10000000; // Rp 10.000.000
  static const int defaultBudget = 500000; // Rp 500.000

  // Device Configuration
  static const int minWatt = 1; // 1 Watt
  static const int maxWatt = 10000; // 10.000 Watt
  static const double minHoursPerDay = 0.1;
  static const double maxHoursPerDay = 24.0;

  // User Configuration
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // Image Configuration
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 85; // 0-100
  static const double maxImageWidth = 1024;
  static const double maxImageHeight = 1024;

  // UI Configuration
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration alertAutoDismiss = Duration(seconds: 5);

  // Database Configuration
  static const String dbName = 'smartwatt.db';
  static const int dbSchemaVersion = 1;

  // Chart Configuration
  static const int chartMaxDataPoints = 30; // 30 hari
  static const double chartBarWidth = 20.0;

  // Usage Calculation
  static const double electricityPricePerKWh = 1352.0; // Rp/kWh (tarif 900 VA)
  static const int daysInMonth = 30;

  // App Info
  static const String appName = 'SmartWatt';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Smart Electricity Usage & Budget Management';

  // Error Messages
  static const String networkError =
      'Koneksi internet bermasalah. Coba lagi nanti.';
  static const String serverError =
      'Server sedang bermasalah. Coba lagi nanti.';
  static const String unknownError = 'Terjadi kesalahan. Coba lagi nanti.';
  static const String timeoutError = 'Koneksi timeout. Periksa internet Anda.';

  // Success Messages
  static const String deviceAdded = 'Perangkat berhasil ditambahkan';
  static const String deviceUpdated = 'Perangkat berhasil diperbarui';
  static const String deviceDeleted = 'Perangkat berhasil dihapus';
  static const String budgetSaved = 'Budget berhasil disimpan';
  static const String profileUpdated = 'Profil berhasil diperbarui';

  // Date Format
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy HH:mm';

  // Greeting Messages
  static List<String> getGreetingByHour(int hour) {
    if (hour >= 5 && hour < 12) {
      return ['Selamat Pagi', '☀️'];
    } else if (hour >= 12 && hour < 15) {
      return ['Selamat Siang', '🌤️'];
    } else if (hour >= 15 && hour < 18) {
      return ['Selamat Sore', '🌅'];
    } else {
      return ['Selamat Malam', '🌙'];
    }
  }

  // Currency Format
  static String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Watt Format
  static String formatWatt(int watt) {
    if (watt >= 1000) {
      return '${(watt / 1000).toStringAsFixed(1)} kW';
    }
    return '$watt W';
  }

  // Kilowatt Hour Format
  static String formatKWh(double kwh) {
    return '${kwh.toStringAsFixed(2)} kWh';
  }
}
