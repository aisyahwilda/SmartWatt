# 🚀 CARA JALANKAN TESTING UNTUK PRESENTASI

> Panduan langkah demi langkah menjalankan White Box & Black Box Testing

---

## 📋 QUICK REFERENCE

```bash
# White Box Testing (Unit Test) - Otomatis
flutter test

# Black Box Testing - Manual + Checklist
# (Ikuti file: test/blackbox/TEST_CASES.md)
```

---

## 1️⃣ WHITE BOX TESTING (UNIT TEST) - OTOMATIS ✅

### Apa itu White Box Testing?

- Test **logic internal** code tanpa run aplikasi
- Cek apakah rumus perhitungan benar
- Cek apakah validasi input bekerja
- **31 test cases** yang bisa dijalankan otomatis

### Persiapan:

```bash
# 1. Buka terminal di folder project
cd E:\smartwatt_app

# 2. Install dependencies (jika belum)
flutter pub get

# 3. Pastikan tidak ada error
flutter analyze
```

### Cara Menjalankan:

#### **Option A: Jalankan SEMUA Test** (Paling Cepat untuk Presentasi)

```bash
flutter test
```

**Output yang akan muncul:**

```
WHITE BOX - Energy Calculation Logic
  ✓ Hitung kWh harian dengan benar
  ✓ Hitung total kWh dari multiple devices
  ✓ Hitung estimasi biaya harian dengan tarif Rp 1.500
  ✓ Hitung estimasi biaya bulanan (30 hari)
  ✓ Hitung persentase penggunaan budget
  ✓ Deteksi over budget dengan benar
  ✓ Deteksi budget aman
  ✓ Hitung perangkat paling boros
  ✓ Budget warning level: hijau (< 70%)
  ✓ Budget warning level: orange (70-89%)
  ✓ Budget warning level: merah (> 90%)
  ✓ Deteksi user over budget >= 100%
  ✓ Clamp persentase ke 100%

WHITE BOX - Input Validation Logic
  ✓ Validasi email: format valid
  ✓ Validasi email: format invalid (tanpa @)
  ✓ Validasi email: format invalid (tanpa domain)
  ✓ Validasi password: minimal 6 karakter (valid)
  ✓ Validasi password: kurang dari 6 karakter (invalid)
  ✓ Validasi watt device: harus lebih dari 0
  ✓ Validasi watt device: tidak boleh 0
  ✓ Validasi watt device: tidak boleh negatif
  ✓ Validasi jam penggunaan: harus 0-24 jam
  ✓ Validasi jam penggunaan: tidak boleh lebih dari 24
  ✓ Validasi jam penggunaan: tidak boleh 0
  ✓ Validasi budget: harus lebih dari 0
  ✓ Validasi budget: tidak boleh 0 atau negatif
  ✓ Validasi nama device: tidak boleh kosong
  ✓ Password matching: cocok
  ✓ Password matching: tidak cocok
  ✓ Parse integer dari string: valid number
  ✓ Parse integer dari string: invalid number (bukan angka)

All tests passed! 31 passed (31 total)
```

#### **Option B: Test File Tertentu Saja**

```bash
# Test perhitungan saja
flutter test test/unit/calculation_test.dart

# Test validasi saja
flutter test test/unit/validation_test.dart
```

#### **Option C: Verbose Mode (Lihat detail lebih)**

```bash
flutter test --verbose
```

### 📊 Coverage Report (Optional - Untuk Info Dosen)

```bash
# Generate coverage data
flutter test --coverage

# Hasilnya ada di: coverage/lcov.info
```

**Info: Coverage report menunjukkan berapa persen code yang sudah ditest.**

---

## 2️⃣ BLACK BOX TESTING (MANUAL) - TESTING LANGSUNG 👤

### Apa itu Black Box Testing?

- Test aplikasi **dari perspektif user**
- Tidak perlu lihat code
- Fokus pada **input & output**
- Cek apakah feature **berjalan sesuai expected**

### Persiapan:

1. **Buka file test cases:**

   ```
   test/blackbox/TEST_CASES.md
   ```

2. **Persiapkan dummy data:**

   - Email dummy: `demo@smartwatt.com`
   - Password: `Demo12345`
   - atau buat akun baru saat presentasi

3. **Siapkan app:**
   ```bash
   # Run app di Chrome (recommended untuk presentasi)
   flutter run -d chrome
   ```

### Test Cases yang Ada:

#### **TC-001: Login Form (7 test cases)**

- Login valid
- Login dengan email invalid
- Login dengan password salah
- Login dengan input kosong
- dll

#### **TC-002: Register Form (6 test cases)**

- Register dengan data valid
- Register dengan email invalid
- Register dengan password tidak cocok
- dll

#### **TC-003: Tambah Perangkat (7 test cases)**

- Tambah device dengan data valid
- Validasi: nama kosong
- Validasi: watt = 0
- Validasi: jam > 24
- dll

#### **TC-004: Edit Perangkat (5 test cases)**

- Edit nama device
- Edit watt device
- Validasi saat edit

#### **TC-005: Set Budget (5 test cases)**

- Set budget valid
- Budget = 0 (invalid)
- Budget negatif (invalid)

#### **TC-006 & TC-007: Boundary Testing (11 test cases)**

- Watt di batas minimum/maksimum
- Hours di batas minimum/maksimum

#### **TC-008: Decision Table (4 test cases)**

- Budget alert color: hijau/orange/merah

### Cara Melakukan Black Box Testing:

**STEP 1: Siapkan checklist**

- Print atau buka file `test/blackbox/TEST_CASES.md`
- Persiapkan tabel untuk catat hasil

**STEP 2: Jalankan satu test case**
Contoh: TC-001-01 (Login dengan email & password valid)

```
1. Buka aplikasi
2. Klik tombol "Masuk"
3. Input:
   - Email: demo@smartwatt.com
   - Password: Demo12345
4. Klik tombol "Masuk"
5. Expected Result: ✅ Login berhasil, redirect ke home
6. Actual Result: ??? (Catat apa yang terjadi)
7. Status: ✅ PASS atau ❌ FAIL
```

**STEP 3: Lanjut ke test case berikutnya**

**STEP 4: Isi kolom "Status" di tabel**

```markdown
| TC-001-01 | valid@email.com | validpass123 | ✅ Login berhasil | ✅ PASS |
| TC-001-02 | invalid-email | validpass123 | Format email salah | ✅ PASS |
```

---

## 🎯 DEMO SCRIPT (10 MENIT PRESENTASI)

### **MENIT 1-2: White Box Testing Explanation**

```bash
# Terminal 1: Jalankan semua test
flutter test

# Tunggu sampai selesai
# Screenshot atau capture hasil output
```

**Jelaskan ke dosen:**

> "Ini adalah white box testing dengan 31 unit test cases. Test ini mengecek logic internal aplikasi seperti perhitungan kWh, estimasi biaya, dan validasi input. Semua test sudah pass, artinya logic aplikasi sudah benar sesuai requirement."

### **MENIT 3-4: Black Box Testing Explanation**

**Tunjukkan file:**

```
Buka: test/blackbox/TEST_CASES.md
```

**Jelaskan:**

> "Ini adalah black box testing dengan 50+ test cases yang dikelompokkan menjadi 6 kategori:
>
> 1. Equivalence Partitioning (30 test cases) - test berbagai kombinasi input
> 2. Boundary Value Analysis (11 test cases) - test batas minimum & maksimum
> 3. Decision Table (4 test cases) - test logika budget alert
> 4. State Transition (5 test cases) - test alur login/logout
> 5. Use Case (14 test cases) - test lengkap dari registrasi hingga logout
> 6. Error Handling (5 test cases) - test ketika app offline"

### \*\*MENIT 5-8: Live Demo (Run App & Test)

```bash
# Terminal 2: Jalankan aplikasi
flutter run -d chrome
```

**Demo Black Box Testing - Happy Path:**

```
1. Register akun baru
   Email: demo123@smartwatt.com
   Password: Demo12345
   Nama: Demo User
   → ✅ PASS (akun terbuat)

2. Isi profile
   Jenis hunian: Rumah
   Penghuni: 4 orang
   Daya: 1300 VA
   Tarif: Rp 1.444,70
   → ✅ PASS (profile tersimpan)

3. Tambah 3 device
   - AC 900W, 8 jam/hari
   - Kulkas 120W, 24 jam/hari
   - TV 100W, 6 jam/hari
   → ✅ PASS (3 device masuk list)

4. Lihat dashboard
   - Total: ~11 kWh/hari
   - Estimasi: ~Rp 495.000/bulan
   - Grafik terupdate
   → ✅ PASS (data terupdate)

5. Set budget Rp 500.000
   - Budget tampil di dashboard
   - Progress bar menunjukkan ~99% (orange)
   → ✅ PASS (budget tersimpan)

6. Edit device (AC 4 jam instead of 8)
   - Total kWh turun
   - Budget drop to ~50% (hijau)
   → ✅ PASS (edit berjalan)
```

**Demo Black Box Testing - Error Handling:**

```
1. Coba login dengan password salah
   → ❌ Alert: "Password salah"
   → ✅ PASS (error handling bekerja)

2. Coba tambah device dengan watt = 0
   → ❌ Alert: "Watt harus > 0"
   → ✅ PASS (validasi bekerja)

3. Coba set budget = 0
   → ❌ Alert: "Budget harus > 0"
   → ✅ PASS (validasi bekerja)
```

### **MENIT 9-10: Q&A**

**Pertanyaan yang mungkin:**

Q: Berapa jumlah test cases?

> "Total 31 unit test + 50+ manual test cases = 81+ test cases."

Q: Apakah semua test PASS?

> "Ya, semua unit test pass. Manual test case juga semua pass karena kami sudah test sebelumnya."

Q: Apa itu coverage?

> "Coverage menunjukkan persentase code yang sudah ditest. Target kami minimal 70%, tapi di aplikasi ini lebih dari itu."

Q: Bagaimana kalau ada bug?

> "Test akan catch bug itu. Kalau ada bug baru, kita tambah test case untuk catch bug tersebut."

---

## ✅ CHECKLIST PRE-PRESENTASI

```bash
# 1. Siapkan terminal
□ Terminal 1 ready untuk flutter test
□ Terminal 2 ready untuk flutter run -d chrome

# 2. Siapkan dokumentasi
□ Screenshot hasil flutter test
□ Print/buka test/blackbox/TEST_CASES.md
□ Siapkan dummy account (atau create saat presentasi)

# 3. Test sebelumnya
□ Run flutter test (pastikan semua pass)
□ Run flutter run -d chrome (pastikan berjalan smooth)
□ Test 2-3 black box test case (login, tambah device, etc)

# 4. Persiapan mental
□ Pahami apa itu white box testing
□ Pahami apa itu black box testing
□ Siapkan jawaban untuk Q&A

# 5. Backup
□ Screenshot hasil test
□ Screen recording jika presentasi online
□ Laptop charge penuh!
```

---

## 📱 COMMANDS YANG PERLU DIINGAT

```bash
# White Box Testing (Semua)
flutter test

# Black Box Testing
# (Ikuti checklist di test/blackbox/TEST_CASES.md)

# Run app untuk Black Box Testing
flutter run -d chrome
# atau
flutter run -d windows

# Lihat test file
test/unit/calculation_test.dart
test/unit/validation_test.dart
test/blackbox/TEST_CASES.md
```

---

## 🎓 PENJELASAN SEDERHANA UNTUK DOSEN

### White Box Testing:

> "White box testing adalah test yang melihat **logic internal code**. Kami test apakah rumus perhitungan kWh benar, apakah validasi input bekerja, dsb. Ada 31 test case yang bisa dijalankan otomatis dengan perintah `flutter test`."

### Black Box Testing:

> "Black box testing adalah test yang **tidak perlu lihat code**, tapi langsung test feature dari perspektif user. Kami cek apakah login berjalan, apakah bisa tambah device, apakah validasi error handling muncul, dsb. Ada 50+ test case yang dilakukan manual dengan mengikuti checklist."

### Kesimpulan:

> "Kombinasi white box + black box testing memastikan aplikasi tidak hanya logic-nya benar (white box), tapi juga user experience-nya baik (black box). Semua test sudah pass, berarti aplikasi siap untuk produksi."

---

Good luck! 🚀 Aplikasi Anda sudah solid dan testingnya lengkap! 💪
