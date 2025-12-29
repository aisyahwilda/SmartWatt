# SmartWatt - Smart Electricity Monitoring App

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

SmartWatt is a Flutter-based mobile application that helps you monitor and optimize your household electricity consumption. With AI-powered recommendations, real-time tracking, and budget management, SmartWatt makes energy savings effortless.

## ✨ Features

### 📱 Core Features

- **User Authentication**: Secure email/password registration and login
- **Device Management**: Add, edit, and delete household appliances with 16 categories
- **Energy Tracking**: Real-time monitoring of electricity consumption (kWh/day)
- **AI Recommendations**: Google Gemini-powered energy-saving recommendations
- **Budget Management**: Set monthly electricity budgets and track spending
- **User Profile**: Manage personal information (residence type, occupants, tariff details)
- **Notifications**: Toggle notifications for energy alerts
- **Local Storage**: All data stored locally using SQLite (Drift ORM)

### 🎨 Categories Supported

Lampu, AC, Kipas Angin, Speaker, Rice Cooker, Microwave, Blender, Kulkas, Laptop, PC, Printer, Monitor, Mesin Cuci, Setrika, Pompa Air

## 📋 Prerequisites

- Flutter SDK (>=3.9.2)
- Dart (>=3.9.2)
- Android SDK 21+ (for Android deployment)
- Git

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/aisyahwilda/SmartWatt_APP.git
cd SmartWatt_APP
```

### 2. Install Dependencies

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3. Setup Environment

```bash
# Copy example env file
cp .env.example .env

# Edit .env with your Gemini API key
# Get key from: https://aistudio.google.com/app/apikey
```

### 4. Run the App

```bash
flutter run
# or specify device
flutter run -d chrome  # Web
flutter run -d emulator-5554  # Android emulator
```

## 📦 Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: Provider 6.0.5
- **Database**: Drift 2.16.0 (SQLite)
- **API Integration**: HTTP 1.2.2 (Google Gemini API)
- **Authentication**: Email/Password with SHA256 hashing
- **UI Components**: Material Design 3
- **Font**: Google Fonts 6.2.1

## 🔑 API Configuration

### Getting Gemini API Key

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Create a new API key
3. **Important**: Restrict the key to Android/iOS apps (for production)
4. Add to `.env` file:

```env
GEMINI_API_KEY=your_api_key_here
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── pages/                    # UI pages (home, settings, profile, etc)
├── providers/                # State management (AuthProvider, etc)
├── services/                 # Business logic (GeminiService, etc)
├── database/                 # Database setup & DAOs
├── widgets/                  # Reusable UI components
├── constants/                # App colors, strings, constants
└── utils/                    # Validators, helpers
```

## 🛠️ Development

### Build Commands

```bash
# Development build
flutter build apk

# Release build (for Play Store)
flutter build appbundle --release

# Web build
flutter build web

# Clean build
flutter clean && flutter pub get
```

### Code Generation

After modifying database tables:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 📝 Documentation

- **Deployment Guide**: See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **Privacy Policy**: See [PRIVACY_POLICY.md](PRIVACY_POLICY.md)
- **Terms of Service**: See [TERMS_OF_SERVICE.md](TERMS_OF_SERVICE.md)

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🐛 Known Issues & Limitations

- Notifications appear when app is opened (not in background without FCM)
- Energy calculations are estimates based on device wattage and usage hours
- AI recommendations require active internet connection
- Gemini API has usage quotas (free tier: 60 requests/minute)

## 🗺️ Roadmap

- [ ] Firebase Cloud Messaging for background notifications
- [ ] Export energy data to CSV/PDF
- [ ] Monthly energy reports
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Family sharing & device permissions
- [ ] IoT integration for real power meter

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 👤 Author

**Aisyah Wilda**

- GitHub: [@aisyahwilda](https://github.com/aisyahwilda)

## 🙏 Acknowledgments

- Google Gemini API for AI recommendations
- Flutter & Dart communities
- Drift ORM for database management

## 📞 Support & Feedback

For bug reports or feature requests, please [create an issue](https://github.com/aisyahwilda/SmartWatt_APP/issues).

---

**Made with ❤️ for a more sustainable future** 🌱⚡
