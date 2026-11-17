# Jawaban untuk App Review (Guideline 2.1 – Information Needed)

## Intinya
- Versi 1.0 (build 12) ditolak 16 Nov 2026 karena Apple **minta info**, bukan karena bug.
- Teks di bawah ditempel ke **App Review Information → Notes**, lalu kirim ulang dengan **build 15** (ikon baru).
- Yang masih kurang: **rekaman layar dari iPhone asli** (lihat bagian "Rekaman").

## Rekaman layar (Rizka, ±2 menit, di iPhone)
1. Pasang build 15 dari app **TestFlight**.
2. Pusat Kontrol → **Rekam Layar**, lalu buka Keepo dari layar utama.
3. Urutan: buka app → pilih **Cerita contoh** (Inggris) → ketuk kata → arti muncul → simpan kata → tab **Kata** (kartu hafalan) → **Ngomong** (latihan bicara) → tab **Sosial**: Masuk/daftar akun → tombol avatar di Home → **Akun kamu** → Keluar → Masuk lagi → **Hapus akun permanen**; tunjukkan juga tombol **Laporkan/Blokir** di status orang lain.
4. Taruh file video di Unduhan PC (atau kirim lewat chat); Claude unggah dan tempel tautannya di Notes.

## Teks Notes (bahasa Inggris, siap tempel)

```
Thank you for the review. Answers to Guideline 2.1:

1) Screen recording (physical iPhone, latest iOS): <LINK VIDEO>

2) Purpose & audience
Keepo helps teenagers and young adults learn a foreign language by reading stories they choose themselves. While reading, the user taps any word or phrase to see its meaning in the sentence, saves new words, reviews them as flashcards, and practices pronunciation. It solves the problem of quitting a book because of unknown words, without translating the whole text up front.

3) How to use the main features (no login required)
- Open the app > Home > "Cerita contoh" (sample stories) and pick a language, e.g. English. Or add your own .txt / .epub / .pdf file, or paste text.
- Tap a word: its meaning appears. Tap "Simpan" to save it.
- Bottom tabs: Home, Baca (reader), Ngomong (speaking practice: microphone + speech recognition; audio is not stored), Kata (saved words as flashcards), Sosial.
- An account is OPTIONAL (progress sync, weekly XP leaderboard, Sosial tab). Sign up via "Masuk" (e.g. on the Sosial tab) with any username and password. Then tap the profile/avatar button at the top of Home to open "Akun kamu". Account deletion: "Akun kamu" > "Hapus akun permanen" (tap twice to confirm); it deletes the account and all its server data.
- User-generated content: in the Sosial tab users can share short reading statuses and follow others. Every post from another user has "Laporkan" (report) and "Blokir" (block) buttons. Profiles are private by default; book text is never shared publicly.

4) External services
- Cloudflare Workers + D1 (our own API: optional account, progress sync, leaderboard, shared-story links).
- Google Translate public endpoint and MyMemory API (word/sentence meaning lookup).
- Apple on-device speech synthesis and speech recognition (Web Speech API in WKWebView).
- Google Fonts, and cdnjs (pdf.js and JSZip to open the user's own PDF/EPUB files).
No payments, no ads, no AI generation of content.

5) Regional differences
The app works the same in all regions. The interface is in Indonesian; reading content is supported in 14 languages.

6) Regulated industry / third-party material
Not applicable. Users only read their own files or our original sample stories.
```
