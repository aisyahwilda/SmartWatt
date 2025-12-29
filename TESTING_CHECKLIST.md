# SmartWatt - Testing Checklist

## 📋 Whitebox Testing (Unit & Widget Tests)

### Unit Tests

#### ✅ Validators Test (`test/unit/validators_test.dart`)

Run with: `flutter test test/unit/validators_test.dart`

**Test Coverage:**

- [x] Email validation
  - Valid formats: test@example.com, user.name@domain.co.id
  - Invalid formats: no @, no domain, spaces
  - Empty/null handling
- [x] Password validation
  - Minimum 6 characters
  - Empty/null handling
- [x] Budget validation
  - Range: Rp 10.000 - Rp 10.000.000
  - Non-numeric handling
  - Empty/null handling
- [x] Device watt validation
  - Range: 1W - 10.000W
  - Non-numeric handling
  - Negative numbers
- [x] Hours per day validation
  - Range: 0.1 - 24.0 hours
  - Decimal support
  - Invalid ranges
- [x] Name validation
  - Length: 2-50 characters
  - Letters and spaces only
  - No numbers or special characters

**Expected Results:**

- All validation tests should pass
- Edge cases handled properly
- Error messages in Indonesian

---

### Widget Tests

#### ✅ Login Page Test (`test/widget/login_page_test.dart`)

Run with: `flutter test test/widget/login_page_test.dart`

**Test Coverage:**

- [x] UI Elements
  - Logo displayed
  - Title "Masuk ke SmartWatt" visible
  - Email field exists
  - Password field exists
  - Login button exists
  - "Belum punya akun? Daftar" text visible
- [x] Password Visibility
  - Password obscured by default
  - Toggle icon changes on tap
- [x] Form Validation
  - Empty email shows error
  - Invalid email format shows error
  - Empty password shows error
  - Short password (< 6 chars) shows error
- [x] Navigation
  - "Daftar" text navigates to register page

**Expected Results:**

- All UI elements render correctly
- Validation works as expected
- Navigation functions properly

---

#### ✅ Home Page Test (`test/widget/home_page_test.dart`)

Run with: `flutter test test/widget/home_page_test.dart`

**Test Coverage:**

- [x] UI Elements
  - Greeting section displays
  - User name from database shown
  - Budget card visible
  - Usage statistics displayed
  - AI recommendations section exists
  - Navigation buttons present
- [x] Navigation
  - "Atur Budget" → Budget page
  - "Kelola Perangkat" → Devices page
  - "Riwayat" → Usage History page
- [x] Data Display
  - Correct budget amount shown
  - Device usage calculated
  - Empty state when no devices
- [x] Interactions
  - Pull-to-refresh works
  - Data reloads on refresh

**Expected Results:**

- All data loads from database
- Calculations are accurate
- Navigation works correctly
- UI updates on data changes

---

## 🖥️ Blackbox Testing (Manual Testing)

### 1. Authentication Flow

#### Registration

- [ ] Open app → Tap "Daftar"
- [ ] Enter invalid email → Error shown
- [ ] Enter short password → Error shown
- [ ] Enter valid email & password → Success
- [ ] Check if user data saved in database
- [ ] Auto-login after registration

**Expected:** Validation works, user created, redirected to home

#### Login

- [ ] Enter invalid credentials → Error shown
- [ ] Enter valid credentials → Success
- [ ] Check if AuthProvider has userId
- [ ] Navigate to home page

**Expected:** Login works, user authenticated, session persists

#### Logout

- [ ] Tap profile → Settings → Logout
- [ ] Confirm logout
- [ ] Check if redirected to login page
- [ ] Try to navigate back → Blocked

**Expected:** User logged out, session cleared, can't access home

---

### 2. Profile Management

#### View Profile

- [ ] Navigate to Profile page
- [ ] Check user name displayed
- [ ] Check email displayed
- [ ] Check profile photo (if set)
- [ ] Check household data (if set)

**Expected:** All user data from database shown correctly

#### Edit Profile

- [ ] Tap edit name → Change name → Save
- [ ] Check if name updates in:
  - Profile page header
  - Settings header
  - Home page greeting
- [ ] Change profile photo → Save
- [ ] Check if photo updated everywhere

**Expected:** Changes persist, UI updates immediately

#### Edit Household Data

- [ ] Tap "Jenis Hunian" → Select option → Save
- [ ] Tap "Jumlah Penghuni" → Enter number → Save
- [ ] Tap "Daya Listrik" → Select VA → Save
- [ ] Tap "Golongan Tarif" → Select tarif → Save
- [ ] Check if all data saved

**Expected:** Household data saved to database

---

### 3. Budget Management

#### Set Budget

- [ ] Navigate to Budget page
- [ ] Enter budget < Rp 10.000 → Error shown
- [ ] Enter valid budget → Save
- [ ] Check if budget appears on home page
- [ ] Navigate back to budget page → Budget loaded

**Expected:** Budget validation works, saved, displayed

#### View Budget History

- [ ] Set budget for current month
- [ ] Change month → Set different budget
- [ ] Return to current month → Previous budget shown
- [ ] Check if chart shows monthly budgets

**Expected:** Budget per month tracked correctly

---

### 4. Device Management

#### Add Device

- [ ] Navigate to Devices page → Tap "+"
- [ ] Leave name empty → Error shown
- [ ] Enter watt = 0 → Error shown
- [ ] Enter hours > 24 → Error shown
- [ ] Enter valid data → Save
- [ ] Check if device appears in list
- [ ] Navigate to home → Check if usage updated

**Expected:** Validation works, device added, usage calculated

#### Edit Device

- [ ] Tap device from list
- [ ] Change watt value → Save
- [ ] Navigate to home → Check updated usage
- [ ] Return to devices → Check changes persisted

**Expected:** Changes saved, calculations updated

#### Delete Device

- [ ] Swipe device left → Tap delete
- [ ] Confirm deletion
- [ ] Check device removed from list
- [ ] Navigate to home → Check usage decreased

**Expected:** Device deleted, usage recalculated

---

### 5. Usage Calculation

#### Daily Usage

- [ ] Add device: 100W, 5 hours/day
- [ ] Expected: 0.5 kWh/day (100W × 5h ÷ 1000)
- [ ] Navigate to home → Check "Total Pemakaian"
- [ ] Add another device: 500W, 2 hours/day
- [ ] Expected: 1.5 kWh/day total

**Expected:** Manual calculation = App calculation

#### Monthly Cost

- [ ] Check "Perkiraan Biaya" on home page
- [ ] Formula: (Total kWh/day × 30) × Tarif per kWh
- [ ] Default tarif: Rp 1.352/kWh (tarif 900 VA)
- [ ] Verify calculation accuracy

**Expected:** Cost calculation matches formula

#### Budget Status

- [ ] Set budget Rp 500.000
- [ ] Add devices until cost > Rp 500.000
- [ ] Check if "OVER BUDGET" warning shown
- [ ] Remove devices until cost < Rp 400.000
- [ ] Check if "Aman" status shown

**Expected:** Budget status updates dynamically

---

### 6. AI Recommendations

#### Generate Recommendations

- [ ] Add at least 3 devices
- [ ] Navigate to home page
- [ ] Check "Rekomendasi AI" section
- [ ] Verify 3 recommendations shown
- [ ] Each starts with emoji
- [ ] Recommendations relevant to devices

**Expected:** AI generates 3 specific recommendations

#### Fallback Mode

- [ ] Turn off internet/WiFi
- [ ] Pull-to-refresh on home page
- [ ] Check if fallback recommendations shown:
  - "💡 Matikan perangkat yang tidak digunakan..."
  - "❄️ Atur suhu AC ke 24–26°C..."
  - "⏰ Gunakan timer pada perangkat..."

**Expected:** Fallback recommendations when offline

---

### 7. Chart & History

#### Usage Chart

- [ ] Navigate to home page
- [ ] Check if chart displays
- [ ] Verify bars show daily usage
- [ ] Check X-axis: dates
- [ ] Check Y-axis: kWh values

**Expected:** Chart renders with data

#### Usage History

- [ ] Navigate to "Riwayat" page
- [ ] Check if past usage records shown
- [ ] Verify dates, kWh, and cost
- [ ] Check if sorted by date (newest first)

**Expected:** History accurate and complete

---

### 8. Settings

#### View Settings

- [ ] Navigate to Profile → Settings icon
- [ ] Check user name displayed at top
- [ ] Check email displayed
- [ ] Check all menu items present

**Expected:** Settings page accessible, data shown

#### Logout

- [ ] Tap "Keluar" button
- [ ] Confirm logout in alert
- [ ] Check if redirected to login page
- [ ] Try to access home → Blocked

**Expected:** Logout works, session cleared

---

## 🔥 Edge Cases & Error Handling

### Network Errors

- [ ] Turn off internet
- [ ] Try to get AI recommendations
- [ ] Check if fallback shown
- [ ] Turn on internet → Pull-to-refresh → AI works

**Expected:** Graceful fallback, recovery on reconnect

### Database Errors

- [ ] Add device with extreme values (9999W, 24h)
- [ ] Check if saves correctly
- [ ] Delete and re-add multiple times
- [ ] Check for memory leaks or crashes

**Expected:** No crashes, data integrity maintained

### UI Responsiveness

- [ ] Test on different screen sizes
- [ ] Rotate device (portrait/landscape)
- [ ] Check if UI adapts properly
- [ ] Test scroll behavior on long lists

**Expected:** UI responsive, no overflow errors

### Simultaneous Actions

- [ ] Open budget page
- [ ] Set budget, immediately navigate away
- [ ] Check if budget saved
- [ ] Repeat for device add/edit

**Expected:** Data saved even with quick navigation

---

## 🚀 Performance Testing

### Load Time

- [ ] Close and reopen app
- [ ] Measure time to home page
- [ ] Should be < 2 seconds

### Database Operations

- [ ] Add 50 devices
- [ ] Check if list scrolls smoothly
- [ ] Check if calculations still accurate

### Memory Usage

- [ ] Open app → Check memory (Task Manager/Xcode)
- [ ] Navigate through all pages
- [ ] Return to home → Check memory again
- [ ] Should not increase significantly

---

## ✅ Production Checklist

### Before Deployment

- [ ] All unit tests pass (`flutter test`)
- [ ] All widget tests pass
- [ ] Manual blackbox testing complete
- [ ] No console errors or warnings
- [ ] .env file has valid GEMINI_API_KEY
- [ ] App icon set
- [ ] Splash screen configured
- [ ] Version number updated (pubspec.yaml)

### Build Commands

```powershell
# Android APK
flutter build apk --release

# Android App Bundle (untuk Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

### Post-Build

- [ ] Test APK/AAB on real device
- [ ] Check file size (< 50MB recommended)
- [ ] Verify all features work on release build
- [ ] No debug logs in production

---

## 📊 Test Summary

### Coverage Target

- **Unit Tests:** 100% (all validators covered)
- **Widget Tests:** 80% (critical flows covered)
- **Manual Tests:** 100% (all features tested)

### Priority Testing

1. ✅ Authentication (High Priority)
2. ✅ Device CRUD (High Priority)
3. ✅ Budget Management (High Priority)
4. ✅ Usage Calculation (High Priority)
5. ✅ AI Recommendations (Medium Priority)
6. ✅ Profile Management (Medium Priority)
7. ✅ Charts & History (Low Priority)

---

**Testing Status:** Ready for Production ✅
**Last Updated:** $(date)
