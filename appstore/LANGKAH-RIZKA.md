# Langkah Rizka untuk App Store (±30 menit + tunggu Apple)

## 1. Daftar Apple Developer (bayar USD 99/tahun)
- Buka developer.apple.com/programs/enroll di iPhone (app "Apple Developer").
- Pilih **Individual**. Verifikasi identitas & bayar.
- Tunggu email "Welcome to the Apple Developer Program" (biasanya 1-2 hari).

## 2. Buat kunci API (5 menit)
- appstoreconnect.apple.com → Users and Access → Integrations → App Store Connect API.
- Generate key, akses **App Manager**. Unduh file `.p8` (hanya sekali).
- Catat **Issuer ID** dan **Key ID**. Team ID ada di developer.apple.com/account.

## 3. Bilang ke Claude "akun Apple sudah aktif"
- Claude memasukkan kunci ke GitHub Secrets, upload TestFlight, isi halaman toko, kirim review.
- Jangan tempel isi `.p8` di chat: simpan di Unduhan PC, Claude ambil dari sana.
