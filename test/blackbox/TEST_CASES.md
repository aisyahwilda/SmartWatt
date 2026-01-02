# SmartWatt - Black Box Test Cases

Dokumen ini berisi test cases untuk testing black box aplikasi SmartWatt.

---

## 1. Authentication & User Management

### TC-001: Register User Baru (Valid)

**Prekondisi:** Aplikasi terbuka di halaman Register

| Step | Action                          | Input              | Expected Result                    | Actual Result      | Status |
| ---- | ------------------------------- | ------------------ | ---------------------------------- | ------------------ | ------ |
| 1    | Tap field "Nama Lengkap"        | "John Doe"         | Field terisi                       | ✅ Field terisi    | PASS   |
| 2    | Tap field "Email"               | "john@example.com" | Field terisi                       | ✅ Field terisi    | PASS   |
| 3    | Tap field "Password"            | "Password123!"     | Field terisi (masked)              | ✅ Field terisi    | PASS   |
| 4    | Tap field "Konfirmasi Password" | "Password123!"     | Field terisi (masked)              | ✅ Field terisi    | PASS   |
| 5    | Tap button "Daftar"             | -                  | Redirect ke Home + success message | ✅ Redirect sukses | PASS   |

---

### TC-002: Register dengan Email Invalid

**Prekondisi:** Aplikasi terbuka di halaman Register

| Step | Action                          | Input          | Expected Result            | Actual Result   | Status |
| ---- | ------------------------------- | -------------- | -------------------------- | --------------- | ------ |
| 1    | Tap field "Nama Lengkap"        | "John Doe"     | Field terisi               | ✅ Field terisi | PASS   |
| 2    | Tap field "Email"               | "invalidemail" | Field terisi               | ✅ Field terisi | PASS   |
| 3    | Tap field "Password"            | "Password123!" | Field terisi               | ✅ Field terisi | PASS   |
| 4    | Tap field "Konfirmasi Password" | "Password123!" | Field terisi               | ✅ Field terisi | PASS   |
| 5    | Tap button "Daftar"             | -              | Error: "Email tidak valid" | ✅ Error muncul | PASS   |

---

### TC-003: Register dengan Password Tidak Match

**Prekondisi:** Aplikasi terbuka di halaman Register

| Step | Action                          | Input              | Expected Result              | Actual Result   | Status |
| ---- | ------------------------------- | ------------------ | ---------------------------- | --------------- | ------ |
| 1    | Tap field "Nama Lengkap"        | "John Doe"         | Field terisi                 | ✅ Field terisi | PASS   |
| 2    | Tap field "Email"               | "john@example.com" | Field terisi                 | ✅ Field terisi | PASS   |
| 3    | Tap field "Password"            | "Password123!"     | Field terisi                 | ✅ Field terisi | PASS   |
| 4    | Tap field "Konfirmasi Password" | "Different123!"    | Field terisi                 | ✅ Field terisi | PASS   |
| 5    | Tap button "Daftar"             | -                  | Error: "Password tidak sama" | ✅ Error muncul | PASS   |

---

### TC-004: Login dengan Email & Password Valid

**Prekondisi:** User sudah terdaftar, aplikasi di halaman Login

| Step | Action               | Input              | Expected Result       | Actual Result   | Status |
| ---- | -------------------- | ------------------ | --------------------- | --------------- | ------ |
| 1    | Tap field "Email"    | "john@example.com" | Field terisi          | ✅ Field terisi | PASS   |
| 2    | Tap field "Password" | "Password123!"     | Field terisi (masked) | ✅ Field terisi | PASS   |
| 3    | Tap button "Masuk"   | -                  | Redirect ke Home      | ✅ Login sukses | PASS   |

---

### TC-005: Login dengan Password Salah

**Prekondisi:** User sudah terdaftar, aplikasi di halaman Login

| Step | Action               | Input              | Expected Result                    | Actual Result   | Status |
| ---- | -------------------- | ------------------ | ---------------------------------- | --------------- | ------ |
| 1    | Tap field "Email"    | "john@example.com" | Field terisi                       | ✅ Field terisi | PASS   |
| 2    | Tap field "Password" | "WrongPassword!"   | Field terisi                       | ✅ Field terisi | PASS   |
| 3    | Tap button "Masuk"   | -                  | Error: "Email atau password salah" | ✅ Error muncul | PASS   |

---

## 2. Device Management

### TC-006: Tambah Perangkat Baru (Valid)

**Prekondisi:** User sudah login, berada di halaman Devices

| Step | Action                                  | Input            | Expected Result                  | Actual Result    | Status |
| ---- | --------------------------------------- | ---------------- | -------------------------------- | ---------------- | ------ |
| 1    | Tap tombol "+" (floating action button) | -                | Dialog "Tambah Perangkat" muncul | ✅ Dialog muncul | PASS   |
| 2    | Tap dropdown "Kategori"                 | -                | List kategori muncul             | ✅ List muncul   | PASS   |
| 3    | Pilih kategori                          | "AC"             | Kategori terpilih                | ✅ AC terpilih   | PASS   |
| 4    | Tap field "Nama Perangkat"              | "AC Kamar Tidur" | Field terisi                     | ✅ Field terisi  | PASS   |
| 5    | Tap field "Watt"                        | "1000"           | Field terisi (angka saja)        | ✅ Field terisi  | PASS   |
| 6    | Tap field "Jam/hari"                    | "8.5"            | Field terisi                     | ✅ Field terisi  | PASS   |
| 7    | Tap button "Simpan"                     | -                | Device tersimpan, muncul di list | ✅ Device muncul | PASS   |

---

### TC-007: Tambah Perangkat dengan Watt Diisi Huruf

**Prekondisi:** User sudah login, dialog "Tambah Perangkat" terbuka

| Step | Action           | Input | Expected Result              | Actual Result       | Status |
| ---- | ---------------- | ----- | ---------------------------- | ------------------- | ------ |
| 1    | Tap field "Watt" | "abc" | Huruf tidak bisa diinput     | ✅ Huruf auto-clear | PASS   |
| 2    |                  |       | Alert: "Masukkan angka saja" | ✅ Alert muncul     | PASS   |

---

### TC-008: Tambah Perangkat dengan Jam Diisi Huruf

**Prekondisi:** User sudah login, dialog "Tambah Perangkat" terbuka

| Step | Action               | Input | Expected Result              | Actual Result       | Status |
| ---- | -------------------- | ----- | ---------------------------- | ------------------- | ------ |
| 1    | Tap field "Jam/hari" | "xyz" | Huruf tidak bisa diinput     | ✅ Huruf auto-clear | PASS   |
| 2    |                      |       | Alert: "Masukkan angka saja" | ✅ Alert muncul     | PASS   |

---

### TC-009: Edit Perangkat

**Prekondisi:** Minimal 1 device sudah ada di list

| Step | Action                             | Input           | Expected Result                | Actual Result      | Status |
| ---- | ---------------------------------- | --------------- | ------------------------------ | ------------------ | ------ |
| 1    | Tap icon edit (pensil) pada device | -               | Dialog "Edit Perangkat" muncul | ✅ Dialog muncul   | PASS   |
| 2    | Ubah field "Nama Perangkat"        | "AC Ruang Tamu" | Field terupdate                | ✅ Field terupdate | PASS   |
| 3    | Ubah field "Watt"                  | "1500"          | Field terupdate                | ✅ Field terupdate | PASS   |
| 4    | Tap button "Simpan"                | -               | Device terupdate di list       | ✅ Update sukses   | PASS   |

---

### TC-010: Hapus Perangkat

**Prekondisi:** Minimal 1 device sudah ada di list

| Step | Action                              | Input | Expected Result          | Actual Result      | Status |
| ---- | ----------------------------------- | ----- | ------------------------ | ------------------ | ------ |
| 1    | Tap icon delete (trash) pada device | -     | Dialog konfirmasi muncul | ✅ Dialog muncul   | PASS   |
| 2    | Tap button "Hapus"                  | -     | Device hilang dari list  | ✅ Device terhapus | PASS   |

---

## 3. Budget Management

### TC-011: Set Budget Listrik (Valid)

**Prekondisi:** User sudah login, berada di halaman Home

| Step | Action                          | Input    | Expected Result                   | Actual Result       | Status |
| ---- | ------------------------------- | -------- | --------------------------------- | ------------------- | ------ |
| 1    | Scroll ke bagian Budget         | -        | Card "Budget Listrik" terlihat    | ✅ Card terlihat    | PASS   |
| 2    | Tap button "Atur Budget"        | -        | Navigate ke Budget Page           | ✅ Navigate sukses  | PASS   |
| 3    | Tap field "Budget Bulanan (Rp)" | "500000" | Field terisi                      | ✅ Field terisi     | PASS   |
| 4    | Tap button "Simpan"             | -        | Budget tersimpan, kembali ke Home | ✅ Budget tersimpan | PASS   |

---

### TC-012: Budget Progress Bar Warna Hijau (< 60%)

**Prekondisi:** Budget = 500000, Total biaya = 250000 (50%)

| Step | Action                            | Input | Expected Result | Actual Result | Status |
| ---- | --------------------------------- | ----- | --------------- | ------------- | ------ |
| 1    | Lihat progress bar budget di Home | -     | Warna hijau     | ✅ Hijau      | PASS   |

---

### TC-013: Budget Progress Bar Warna Kuning (60-80%)

**Prekondisi:** Budget = 500000, Total biaya = 350000 (70%)

| Step | Action                            | Input | Expected Result | Actual Result | Status |
| ---- | --------------------------------- | ----- | --------------- | ------------- | ------ |
| 1    | Lihat progress bar budget di Home | -     | Warna kuning    | ✅ Kuning     | PASS   |

---

### TC-014: Budget Progress Bar Warna Merah (> 80%)

**Prekondisi:** Budget = 500000, Total biaya = 450000 (90%)

| Step | Action                            | Input | Expected Result | Actual Result | Status |
| ---- | --------------------------------- | ----- | --------------- | ------------- | ------ |
| 1    | Lihat progress bar budget di Home | -     | Warna merah     | ✅ Merah      | PASS   |

---

## 4. Profile & Settings

### TC-015: Update Profile (Nama & Email)

**Prekondisi:** User sudah login, berada di halaman Settings

| Step | Action                        | Input              | Expected Result   | Actual Result      | Status |
| ---- | ----------------------------- | ------------------ | ----------------- | ------------------ | ------ |
| 1    | Tap field "Nama Lengkap"      | "Jane Doe"         | Field terupdate   | ✅ Field terupdate | PASS   |
| 2    | Tap field "Email"             | "jane@example.com" | Field terupdate   | ✅ Field terupdate | PASS   |
| 3    | Tap button "Simpan Perubahan" | -                  | Profile tersimpan | ✅ Update sukses   | PASS   |

---

### TC-016: Logout dari Aplikasi

**Prekondisi:** User sudah login

| Step | Action                | Input | Expected Result          | Actual Result    | Status |
| ---- | --------------------- | ----- | ------------------------ | ---------------- | ------ |
| 1    | Buka halaman Settings | -     | Halaman Settings terbuka | ✅ Terbuka       | PASS   |
| 2    | Scroll ke bawah       | -     | Tombol "Keluar" terlihat | ✅ Terlihat      | PASS   |
| 3    | Tap button "Keluar"   | -     | Dialog konfirmasi muncul | ✅ Dialog muncul | PASS   |
| 4    | Tap "Ya, Keluar"      | -     | Redirect ke Login        | ✅ Logout sukses | PASS   |

---

### TC-017: Hapus Akun

**Prekondisi:** User sudah login, berada di halaman Settings

| Step | Action                  | Input | Expected Result                  | Actual Result    | Status |
| ---- | ----------------------- | ----- | -------------------------------- | ---------------- | ------ |
| 1    | Scroll ke bawah         | -     | Tombol "Hapus Akun" terlihat     | ✅ Terlihat      | PASS   |
| 2    | Tap button "Hapus Akun" | -     | Dialog konfirmasi muncul         | ✅ Dialog muncul | PASS   |
| 3    | Tap "Ya, Hapus Akun"    | -     | Data terhapus, redirect ke Login | ✅ Akun terhapus | PASS   |

---

## 5. AI Recommendations (Gemini Integration)

### TC-018: Tampilkan Rekomendasi AI

**Prekondisi:** User sudah login, minimal 1 device ada, internet ON

| Step | Action            | Input | Expected Result                 | Actual Result         | Status |
| ---- | ----------------- | ----- | ------------------------------- | --------------------- | ------ |
| 1    | Buka halaman Home | -     | Section "Rekomendasi AI" muncul | ✅ Section muncul     | PASS   |
| 2    | Tunggu loading    | -     | 3 rekomendasi muncul            | ✅ Rekomendasi muncul | PASS   |

---

## 6. Navigation & UI

### TC-019: Bottom Navigation Bar

**Prekondisi:** User sudah login

| Step | Action                | Input | Expected Result          | Actual Result | Status |
| ---- | --------------------- | ----- | ------------------------ | ------------- | ------ |
| 1    | Tap icon "Dashboard"  | -     | Halaman Home terbuka     | ✅ Terbuka    | PASS   |
| 2    | Tap icon "Perangkat"  | -     | Halaman Devices terbuka  | ✅ Terbuka    | PASS   |
| 3    | Tap icon "Pengaturan" | -     | Halaman Settings terbuka | ✅ Terbuka    | PASS   |

---

### TC-020: Navbar di Atas Tombol Sistem (Safe Area)

**Prekondisi:** User sudah login, HP dengan navigation buttons

| Step | Action              | Input | Expected Result              | Actual Result    | Status |
| ---- | ------------------- | ----- | ---------------------------- | ---------------- | ------ |
| 1    | Lihat posisi navbar | -     | Navbar di atas tombol sistem | ✅ Safe area OK  | PASS   |
| 2    | Tap icon navbar     | -     | Tidak tertutup tombol sistem | ✅ Tap berfungsi | PASS   |

---

### TC-021: Persistent Login (Auto Login)

**Prekondisi:** User sudah login sebelumnya

| Step | Action                      | Input | Expected Result                  | Actual Result | Status |
| ---- | --------------------------- | ----- | -------------------------------- | ------------- | ------ |
| 1    | Tutup aplikasi (force stop) | -     | App tertutup                     | ✅ Tertutup   | PASS   |
| 2    | Buka aplikasi kembali       | -     | Splash screen → langsung ke Home | ✅ Auto login | PASS   |

---

## 7. Responsive UI

### TC-022: Total Penggunaan Hari Ini (Angka Panjang)

**Prekondisi:** Total KWH = 12345.67 (angka panjang)

| Step | Action                                 | Input | Expected Result            | Actual Result        | Status |
| ---- | -------------------------------------- | ----- | -------------------------- | -------------------- | ------ |
| 1    | Lihat card "Total Penggunaan Hari Ini" | -     | Angka tidak terpotong      | ✅ Angka lengkap     | PASS   |
| 2    |                                        |       | Text auto-scale jika perlu | ✅ FittedBox bekerja | PASS   |

---

## Summary

**Total Test Cases:** 22  
**Passed:** 22  
**Failed:** 0  
**Success Rate:** 100%

---

## Notes

- Semua test cases dilakukan di Android
- Testing dilakukan dengan data dummy
- AI Recommendations tested dengan API key valid
- Safe area tested di device dengan navigation buttons

---

**Tested by:** QA Team  
**Date:** January 2, 2026  
**App Version:** 1.0.0+1
