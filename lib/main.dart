import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants/colors_app.dart';
import 'database/app_database.dart';
import 'pages/splash_screen.dart';
import 'pages/hero_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/devices_page.dart';
import 'pages/settings_page.dart';
import 'providers/auth_provider.dart';
import 'services/gemini_service.dart';
import 'providers/recommendation_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        Provider<GeminiService>(create: (_) => GeminiService()),
        ChangeNotifierProvider(
          create: (context) => RecommendationProvider(
            context.read<AppDatabase>(),
            context.read<GeminiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AppDatabase>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartWatt',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.deepTeal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.deepTeal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/hero': (context) => const HeroScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const SmartWattDashboard(),
        '/devices': (context) => const DevicesPage(),
        '/settings': (context) => const SettingsPage(),
        '/home_recommendations': (context) => const HomeScreen(),
      },
    );
  }
}
