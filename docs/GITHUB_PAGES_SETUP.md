# 🚀 Cara Upload Account Deletion Page ke GitHub Pages

## Langkah 1: Push File ke GitHub

### A. Commit file yang baru dibuat:

```bash
cd e:\smartwatt_app
git add docs/account-deletion.html
git commit -m "Add account deletion page for Google Play Store compliance"
git push origin main
```

---

## Langkah 2: Aktifkan GitHub Pages

1. **Buka Repository di GitHub:**

   - Masuk ke https://github.com/aisyahwilda/SmartWatt

2. **Buka Settings:**

   - Klik tab **Settings** (⚙️) di bagian atas repo

3. **Masuk ke Pages:**

   - Di sidebar kiri, klik **Pages**

4. **Configure GitHub Pages:**

   - **Source:** Pilih **Deploy from a branch**
   - **Branch:** Pilih **main**
   - **Folder:** Pilih **/ (root)**
   - Klik tombol **Save**

5. **Tunggu Deployment (2-3 menit)**
   - Refresh halaman setelah 2-3 menit
   - Akan muncul notifikasi: "Your site is live at https://aisyahwilda.github.io/SmartWatt/"

---

## Langkah 3: Dapatkan URL untuk Google Play Console

Setelah GitHub Pages aktif, URL halaman account deletion Anda adalah:

```
https://aisyahwilda.github.io/SmartWatt/docs/account-deletion.html
```

---

## Langkah 4: Masukkan URL ke Google Play Console

1. **Login ke Google Play Console:**

   - https://play.google.com/console

2. **Pilih App SmartWatt**

3. **Masuk ke Policy → App Content:**

   - Di sidebar kiri: **Policy** → **App content**

4. **Cari Section "Data safety":**

   - Scroll ke section **Data safety**
   - Klik **Manage**

5. **Tambahkan Delete Account URL:**

   - Cari field: **"Delete account URL"** atau **"Account deletion"**
   - Paste URL: `https://aisyahwilda.github.io/SmartWatt/docs/account-deletion.html`
   - Klik **Save**

6. **Submit for Review:**
   - Klik **Submit** untuk review oleh Google Play

---

## ✅ Checklist Verifikasi

Pastikan halaman account-deletion.html memenuhi requirement Google Play:

- ✅ **Menyebutkan nama developer:** "SmartWatt Team" ✓
- ✅ **Langkah-langkah jelas:** 5 langkah detail dengan screenshot visual ✓
- ✅ **Daftar data yang dihapus:** Lengkap dengan emoji dan kategorisasi ✓
- ✅ **Daftar data yang tidak dihapus:** Ada penjelasan backup & log ✓
- ✅ **Periode retensi:** Timeline 0-90 hari dijelaskan ✓
- ✅ **Kontak support:** Email support@smartwatt.app ✓

---

## 🔍 Troubleshooting

### **Error: 404 Page Not Found**

**Solusi:**

- Tunggu 5-10 menit setelah push (GitHub Pages butuh waktu deploy)
- Pastikan file ada di folder `docs/` di branch `main`
- Cek kembali URL: harus ada `/docs/account-deletion.html`

### **Error: GitHub Pages tidak muncul di Settings**

**Solusi:**

- Pastikan repo bersifat **Public** (bukan Private)
- Go to Settings → Change visibility to Public jika masih Private

### **Google Play masih reject URL**

**Solusi:**

- Pastikan URL bisa diakses di browser (buka incognito/private mode)
- Cek apakah halaman load dengan benar (tidak error)
- Screenshot halaman dan attach di Google Play Console review comment

---

## 📱 Alternative: Gunakan Custom Domain (Optional)

Jika punya domain sendiri (misal: smartwatt.app), bisa setup custom domain:

1. Di GitHub Pages Settings → Custom domain
2. Masukkan: `smartwatt.app` atau `www.smartwatt.app`
3. Add CNAME record di DNS provider
4. URL jadi: `https://smartwatt.app/docs/account-deletion.html`

---

## 💡 Tips

- **Simpan URL ini:** https://aisyahwilda.github.io/SmartWatt/docs/account-deletion.html
- **Share ke user** yang ingin hapus akun via email/support
- **Update halaman** kapanpun ada perubahan privacy policy (tinggal edit HTML & push)

---

## 🎯 Next Steps

Setelah URL aktif:

1. ✅ Test buka URL di browser
2. ✅ Paste URL ke Google Play Console
3. ✅ Submit app untuk review
4. ✅ Tunggu approval dari Google (1-3 hari)

**Good luck dengan deployment! 🚀**
