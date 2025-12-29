# 🚀 Quick Deployment & GitHub Push Checklist

## ✅ Pre-Deployment Steps

### STEP 1: Revoke Old API Key (DO THIS FIRST!)

```
❌ SECURITY RISK: Your old API key is exposed
1. Go: https://aistudio.google.com/app/apikey
2. Find the key: AIzaSyA9ELazal35EqCKAcPoSgQ_-R47GJxzFf0
3. Click 🗑️ Delete button
4. Confirm deletion
5. Wait 5 minutes for propagation
```

### STEP 2: Create New API Key with Restrictions

```
1. Go: https://aistudio.google.com/app/apikey
2. Click "Create API key"
3. Click "Restrict key"
4. Select: "Android apps" or "All applications"
5. For Production: Add SHA-1 fingerprint & package name
6. Copy the NEW key
```

### STEP 3: Update Local .env File

```bash
# Edit .env file with new API key
GEMINI_API_KEY=AIza_YOUR_NEW_KEY_HERE

# Verify .env is in .gitignore (should be!)
cat .gitignore | grep .env
# Output should show: .env
```

### STEP 4: Test Locally

```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Test in development
flutter run -d chrome  # or your device

# Verify app works and fetches AI recommendations
```

---

## 📤 Push to GitHub

### STEP 1: Initialize Git & Configure User (First Time Only)

```bash
# Check if git is initialized
cd e:\smartwatt_app

# Configure git (if first time)
git config --global user.name "Aisyah Wilda"
git config --global user.email "your-email@example.com"

# Check config
git config --global user.name
git config --global user.email
```

### STEP 2: Check Git Status

```bash
# See what files are ready to commit
git status

# You should see:
# ✅ Modified: pubspec.yaml
# ✅ New: DEPLOYMENT_GUIDE.md
# ✅ New: PRIVACY_POLICY.md
# ✅ New: TERMS_OF_SERVICE.md
# ✅ New: .env.example

# ❌ Should NOT see: .env (must be ignored!)
```

### STEP 3: Add & Commit Changes

```bash
# Add all tracked changes
git add .

# Commit with meaningful message
git commit -m "Initial release: SmartWatt v1.0.0

- Device management with 16 categories
- AI-powered energy recommendations
- Budget tracking & notifications
- Local SQLite database
- Real-time profile updates
- Ready for Play Store deployment"
```

### STEP 4: Set Remote Repository (First Time Only)

```bash
# Check if remote already exists
git remote -v

# If not, add remote
git remote add origin https://github.com/aisyahwilda/SmartWatt_APP.git

# Verify
git remote -v
# Should output:
# origin  https://github.com/aisyahwilda/SmartWatt_APP.git (fetch)
# origin  https://github.com/aisyahwilda/SmartWatt_APP.git (push)
```

### STEP 5: Push to GitHub

```bash
# Set main branch & push
git branch -M main
git push -u origin main

# For future pushes, just use:
git push origin main
```

### STEP 6: Create Release Tag (Optional but Recommended)

```bash
# Tag for version 1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0 - Initial release"

# Push tag to GitHub
git push origin v1.0.0

# View all tags
git tag -l
```

---

## 📤 Build for Play Store

### STEP 1: Create Android Keystore

```bash
# ONLY DO THIS ONCE!
# Run from your home directory

# Windows
keytool -genkey -v -keystore %USERPROFILE%\smartwatt-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias smartwatt-key

# macOS/Linux
keytool -genkey -v -keystore ~/smartwatt-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias smartwatt-key

# When prompted:
# - First name: Smartwatt
# - Last name: App
# - Organization: Aisyah Wilda
# - Organization Unit: Development
# - City/Locality: Jakarta
# - State/Province: DKI Jakarta
# - Country Code: ID
# - Keystore password: (create strong password, save it!)
# - Key password: (same as above)
```

**⚠️ SAVE THIS KEYSTORE FILE SECURELY!** You'll need it for future updates.

### STEP 2: Configure Signing in Android

1. Copy keystore to android folder:

```bash
# Windows
copy %USERPROFILE%\smartwatt-keystore.jks android\

# macOS/Linux
cp ~/smartwatt-keystore.jks android/
```

2. Create `android/key.properties`:

```properties
storeFile=smartwatt-keystore.jks
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=smartwatt-key
```

**⚠️ ADD TO .gitignore!**

```bash
echo "android/key.properties" >> .gitignore
echo "android/smartwatt-keystore.jks" >> .gitignore
```

3. Add to `android/app/build.gradle` (if not already there):

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
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

### STEP 3: Update App Version & ID

Edit `android/app/build.gradle`:

```gradle
defaultConfig {
    applicationId "com.smartwatt.app"  // Unique ID
    minSdkVersion 21
    targetSdkVersion 33
    versionCode 1          // Increment for each release
    versionName "1.0.0"
}
```

### STEP 4: Build App Bundle for Play Store

```bash
# Clean build
flutter clean
flutter pub get

# Build release app bundle
flutter build appbundle --release

# Output: build/app/release/app-release.aab
# Size should be < 150MB
```

### STEP 5: Verify Build

```bash
# Check if build succeeded
ls -la build/app/release/app-release.aab

# Should see file size, e.g.:
# -rw-r--r--  1 user  group  45M Dec 28 2025  app-release.aab
```

---

## 🎮 Create Play Store Listing

### STEP 1: Create Developer Account

1. Go: https://play.google.com/console
2. Pay $25 one-time fee
3. Fill out business info
4. Wait for approval (~1 hour)

### STEP 2: Create App Listing

1. Click "Create app"
2. App name: **SmartWatt**
3. Default language: **English**
4. App type: **Free**
5. Category: **Utilities**
6. Content rating: **E (Everyone)**

### STEP 3: Fill App Details

- Short desc: "Monitor and save electricity with AI"
- Full desc: (copy from README.md)
- Screenshots: 1080×1920px (5 recommended)
- Feature graphic: 1024×500px
- Icon: 512×512px

### STEP 4: Upload App Bundle

1. Go: **Release → Production**
2. Click **Create new release**
3. Upload: `app-release.aab`
4. Release notes: "Initial release"
5. Review & submit

### STEP 5: Wait for Review

- Usually 1-3 hours for initial review
- Can take 24-48 hours for full review
- Check email for approval/rejection

---

## 📝 Future Updates

### For Each New Release:

```bash
# 1. Make code changes
# ...edit code...

# 2. Increment versionCode in android/app/build.gradle
#    versionCode: 1 → 2
#    versionName: "1.0.0" → "1.0.1"

# 3. Commit & push to GitHub
git add .
git commit -m "v1.0.1: Bug fixes and improvements"
git push origin main

# 4. Create release tag
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1

# 5. Build new bundle
flutter build appbundle --release

# 6. Upload to Play Store Console
#    Release → Production → Create new release → Upload AAB
```

---

## ✅ Final Checklist Before Submitting

```
Pre-Submission:
☐ API key is revoked (old one deleted)
☐ New API key has Android restrictions
☐ .env is NOT in git repo
☐ .env.example exists
☐ Privacy Policy created
☐ Terms of Service created
☐ README.md is complete
☐ App builds without errors
☐ Tested on Android device/emulator
☐ All features work (auth, devices, budget, AI)

Play Store:
☐ Developer account created
☐ App ID is unique (com.smartwatt.app)
☐ versionCode & versionName updated
☐ Keystore created & backed up
☐ Screenshots prepared (1080×1920)
☐ Feature graphic prepared (1024×500)
☐ Icon prepared (512×512)
☐ Store listing completed
☐ Privacy policy URL set
☐ App bundle uploaded

GitHub:
☐ Code committed with meaningful messages
☐ Release tag created (v1.0.0)
☐ All branches pushed
```

---

## 🆘 Troubleshooting

### "API key not found" error

```bash
# Check .env exists
test -f .env && echo "✅ .env found" || echo "❌ .env missing"

# Check format
cat .env
# Should show: GEMINI_API_KEY=AIza...

# Verify flutter_dotenv loads it
flutter pub get
```

### "Build failed" error

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build appbundle --release
```

### "Git push rejected"

```bash
# Check remote URL
git remote -v

# Update if wrong
git remote set-url origin https://github.com/aisyahwilda/SmartWatt_APP.git

# Try push again
git push -u origin main
```

### "Play Store upload rejected"

- Check error message in console
- Common issues:
  - App name duplicated (use unique ID)
  - Content rating missing
  - Privacy policy not accessible
  - Screenshot format wrong

---

## 🎉 You're Ready!

After following all steps, your app will be:

- ✅ Deployed on GitHub
- ✅ Ready for Play Store
- ✅ Production-ready

**Estimated time:** 30 minutes setup + 24-48 hours Play Store review

Good luck! 🚀
