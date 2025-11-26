# Setup Gemini AI untuk SmartWatt

## Langkah-langkah Setup:

### 1. Dapatkan API Key Gemini

1. Buka https://makersuite.google.com/app/apikey
2. Login dengan akun Google
3. Klik **"Create API Key"**
4. Copy API key yang dibuat

### 2. Masukkan API Key ke Aplikasi

Buka file `lib/services/gemini_service.dart` dan ganti:

```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

Dengan API key kamu:

```dart
static const String _apiKey = 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
```

### 3. Install Package

Jalankan di terminal:

```bash
flutter pub get
```

### 4. Test Aplikasi

1. Jalankan aplikasi
2. Tambahkan beberapa perangkat di halaman **Perangkat**
3. Kembali ke halaman **Home/Dashboard**
4. Tunggu beberapa detik, rekomendasi AI akan muncul

## Troubleshooting

### Error: API Key not valid

- Pastikan API key sudah benar
- Cek di Google AI Studio apakah API key masih aktif
- Pastikan tidak ada spasi di awal/akhir API key

### Rekomendasi tidak muncul

- Cek koneksi internet
- Lihat console untuk error message
- Pastikan sudah ada perangkat yang ditambahkan

### Rekomendasi generic/fallback terus

- Ini terjadi jika Gemini API gagal
- Cek API key dan koneksi internet
- Lihat error di console dengan `flutter run` di terminal

## Fitur AI Recommendations

Gemini AI akan memberikan rekomendasi berdasarkan:

- ✅ Perangkat yang digunakan (nama, watt, jam pemakaian)
- ✅ Total konsumsi listrik harian
- ✅ Budget bulanan (jika sudah diatur)
- ✅ Perangkat dengan konsumsi tertinggi

Rekomendasi akan otomatis di-refresh setiap kali:

- Menambah/edit/hapus perangkat
- Kembali ke halaman home

## Keamanan API Key

⚠️ **PENTING:**

- Jangan commit API key ke Git
- Jangan share API key ke publik
- Untuk production, gunakan backend server untuk menyimpan API key
- API key gratis Gemini punya limit request per hari

## Alternatif (Optional)

Jika tidak ingin pakai Gemini AI, aplikasi akan tetap menampilkan rekomendasi fallback yang sudah di-hardcode.
