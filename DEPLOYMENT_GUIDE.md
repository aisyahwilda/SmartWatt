# SmartWatt Deployment Guide

## Prerequisites

- Flutter SDK (>=3.9.2)
- Android SDK & Android Studio
- Java Development Kit (JDK)
- Git

## Setup Environment

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

### 3. Configure API Key

```bash
# Copy .env.example to .env
cp .env.example .env

# Edit .env with your Gemini API key
# GEMINI_API_KEY=your_api_key_here
```

**Important:** Get a new API key from https://aistudio.google.com/app/apikey with Android/iOS restrictions.

## Building for Android

### 1. Create Keystore

```bash
# Only do this ONCE for production
keytool -genkey -v -keystore ~/smartwatt-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias smartwatt-key \
  -storepass smartwatt_password \
  -keypass smartwatt_keypass
```

Save the keystore file securely! You'll need it for future updates.

### 2. Configure Signing

Create/edit `android/key.properties`:

```properties
storeFile=../smartwatt-keystore.jks
storePassword=smartwatt_password
keyPassword=smartwatt_keypass
keyAlias=smartwatt-key
```

Add to `android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Update App ID & Version

Edit `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 33

    defaultConfig {
        applicationId "com.smartwatt.app"  # Change to your unique ID
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1          # Increment for each release
        versionName "1.0.0"
    }
}
```

### 4. Build Release APK (for testing)

```bash
flutter build apk --release
# Output: build/app/release/app-release.apk
```

### 5. Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
# Output: build/app/release/app-release.aab
```

## Upload to Play Store

### 1. Create Google Play Developer Account

- Go to https://play.google.com/console
- Pay $25 one-time registration fee
- Complete all required forms

### 2. Create New Application

- App name: "SmartWatt"
- Default language: English
- App type: Free
- Category: Utilities
- Content rating: E (Everyone)

### 3. Prepare Store Listing

- **Short description:** "Monitor and save electricity usage with AI"
- **Full description:** Min 80, max 4000 characters
- **Screenshots:** 1080×1920 px (min 2, recommended 5)
- **Feature graphic:** 1024×500 px
- **Icon:** 512×512 px
- **Privacy policy:** https://your-domain.com/privacy (or link to GitHub)
- **Contact email:** your-email@example.com

### 4. Upload App Bundle

1. Go to **Release → Production**
2. **Create new release** → Upload app-release.aab
3. Add **Release notes:** "Initial release"
4. Submit for review

### 5. Wait for Review

- Initial review: 1-3 hours (usually)

5. Full review: 24-48 hours

- Rollout: Gradual (5% → 25% → 100%) is safer

## Updating the App

### For Bug Fixes / Minor Updates

```bash
# 1. Increment versionCode in build.gradle
#    versionCode: 1 → 2

# 2. Keep versionName same or minor bump
#    versionName: "1.0.0" → "1.0.1"

# 3. Build & submit new bundle
flutter build appbundle --release
```

### For Major Updates

```bash
# 1. Increment both versionCode AND versionName
#    versionCode: 2 → 3
#    versionName: "1.0.1" → "1.1.0"

# 2. Update version in pubspec.yaml too
#    version: 1.1.0+3
```

## Push to GitHub

### 1. Initialize Git (if not already done)

```bash
git init
git add .
git commit -m "Initial commit: SmartWatt app"
```

### 2. Add Remote Repository

```bash
git remote add origin https://github.com/aisyahwilda/SmartWatt_APP.git
git branch -M main
git push -u origin main
```

### 3. Future Updates

```bash
git add .
git commit -m "Describe your changes"
git push origin main
```

### 4. Create Release Tags (Optional but recommended)

```bash
# Tag for version 1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## Troubleshooting

### Build fails: "Android SDK not found"

```bash
flutter doctor --android-licenses
```

### Build fails: "Gradle sync failed"

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### API key not working

- Check `.env` file is in root directory
- Ensure `flutter_dotenv` is properly imported
- Verify API key restrictions don't block your app

### App crashes on startup

- Check logcat: `flutter logs`
- Ensure database migrations are correct
- Verify all required permissions are granted

## Security Checklist

- [ ] API key has Android/iOS restrictions (not global)
- [ ] `.env` file is in `.gitignore`
- [ ] Keystore file is backed up securely (NOT in Git)
- [ ] No sensitive data hardcoded in code
- [ ] Privacy Policy & Terms are publicly accessible
- [ ] HTTPS is used for all API calls

## Support & Feedback

For issues, create an issue on GitHub: https://github.com/aisyahwilda/SmartWatt_APP/issues

---

**Happy deploying! 🚀**
