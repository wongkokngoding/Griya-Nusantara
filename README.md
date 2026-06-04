# 🏛️ Griya Nusantara

**Griya Nusantara** adalah aplikasi edukasi budaya berbasis mobile (Flutter) yang dirancang untuk mengenalkan keanekaragaman rumah adat di Indonesia secara interaktif, modern, dan menyenangkan. Aplikasi ini menggunakan elemen **gamifikasi** (XP, Level, dan Badge) untuk memotivasi pengguna dalam mempelajari sejarah, arsitektur, dan filosofi di balik setiap rumah adat di berbagai wilayah Indonesia.

Proyek ini dikembangkan sebagai bagian dari **Tugas Akhir / Ujian Akhir Semester (UAS) mata kuliah Pemrograman Mobile**.

## ✨ Fitur Utama

### 1. Sistem Autentikasi Pengguna
* **Firebase Authentication Integration**: Pendaftaran akun baru, masuk log (login), serta pemulihan kata sandi (forgot password) yang aman.
* **Sesi Terjaga**: Aplikasi mendeteksi status login pengguna saat pertama kali dibuka untuk langsung mengarahkan ke beranda.

### 2. Eksplorasi Rumah Adat (Home / Explore)
* **Sambutan Personal**: Menyapa pengguna berdasarkan nama profil yang tersimpan di Firestore.
* **Pencarian Real-Time**: Cari rumah adat berdasarkan nama rumah, nama provinsi, maupun pulau (Sumatera, Jawa, Kalimantan, Sulawesi, Papua).
* **Rekomendasi Populer**: Pintasan cepat untuk membaca rumah-rumah adat ikonik seperti Rumah Gadang, Joglo, Honai, dll.

### 3. Peta Indonesia Interaktif (Interactive Regions Map)
* **Peta SVG Dinamis**: Render peta kepulauan Indonesia (`assets/indonesia.svg`) dengan PIN penanda interaktif pada 5 pulau utama.
* **Pin Animasi Berdenyut**: Efek visual dinamis yang mengundang pengguna untuk berinteraksi.
* **Slide-Up Bottom Sheet**: Ketika pin pulau diketuk, akan muncul laci geser berisi daftar seluruh rumah adat yang berasal dari wilayah tersebut beserta pintasan jelajahnya.

### 4. Detail Rumah Adat & Informasi Mendalam
* **Hero Image Animation**: Transisi visual gambar rumah adat yang halus saat berpindah halaman.
* **Lokasi & Chip Wilayah**: Penanda geografis asal rumah adat secara visual.
* **Filosofi & Struktur Arsitektur**: Artikel edukatif mengenai sejarah, makna filosofis bangunan, serta bahan-bahan struktural yang digunakan.
* **Fakta Menarik (Fun Facts)**: Trivia edukatif yang memuat hal-hal unik dari rumah adat terkait.
* **Sistem Favorit**: Simpan rumah adat yang disukai ke dalam koleksi pustaka pribadi (Library) secara real-time.
* **Akses Kuis Langsung**: Tombol cepat untuk menguji pemahaman seputar wilayah rumah adat yang sedang dibaca.

### 5. Kuis Edukasi Kebudayaan
* **6 Kategori Kuis**: Pengguna dapat memilih untuk bermain kuis dengan materi Acak (Nusantara) atau spesifik per pulau (Sumatera, Jawa, Kalimantan, Sulawesi, Papua).
* **Pengacakan Soal**: Kuis mengambil maksimal 10 soal secara acak dari total 100 bank soal kebudayaan di Firestore.
* **Interaksi Kuis Interaktif**: Dilengkapi dengan timer per soal, skor berjalan, feedback warna (Hijau untuk jawaban benar, Merah untuk salah), serta animasi transisi antarsoal.

### 6. Sistem Gamifikasi (XP, Level, & Lencana)
Setiap kali menyelesaikan kuis, pengguna akan menerima poin pengalaman (XP) yang diakumulasikan untuk naik tingkat (Level). Selain itu, terdapat sistem pencapaian **Lencana (Badges)** yang dapat dikoleksi:
* **First Quiz**: Menyelesaikan kuis pertama kali.
* **Perfect Score**: Menjawab seluruh pertanyaan kuis dengan benar (skor 100%).
* **Cultural Hero**: Menyelesaikan kuis dengan skor minimal 70%.
* **Explorer [Wilayah]**: Menyelesaikan kuis wilayah tertentu dengan skor minimal 40%.
* **Master [Wilayah]**: Mendapatkan nilai sempurna (100%) pada kuis wilayah tertentu.
* **Level [N] Achieved**: Meraih tingkat level tertentu.
* **Penyematan Lencana (Featured Badge)**: Pengguna dapat memilih satu lencana kebanggaan mereka untuk dipasang (pinned) secara menonjol di halaman profil.

### 7. Koleksi Favorit (Koleksi)
* Menampilkan daftar rumah adat yang ditandai sebagai favorit oleh pengguna.
* Data disinkronkan secara real-time per pengguna melalui sub-koleksi Firestore.

### 8. Kustomisasi Profil, Pengaturan & Umpan Balik (Feedback)
* **Avatar Picker**: Memilih salah satu dari 8 karakter avatar unik nusantara untuk mewakili profil pengguna.
* **Melacak Kemajuan**: Progress bar XP yang interaktif dan informasi gelar tingkatan level.
* **Edit Nama & Hapus Akun**: Dukungan penuh untuk pengelolaan data pribadi pengguna secara mandiri.
* **Saran dan Masukan (User Feedback)**: Halaman khusus yang terhubung dari menu pengaturan bagi pengguna untuk menyampaikan feedback. Kolom Nama dan Email terisi secara otomatis dari database Firebase, dan masukan disimpan langsung ke Firestore pada koleksi `feedbacks`.

---

## Desain & Palet Warna (Aesthetic Design System)
Griya Nusantara didesain dengan konsep **Heritage Premium** yang memadukan warna-warna alam nusantara:
* **Warna Utama (Primary)**: `Forest Green` (`#1B4332`) - Melambangkan kekayaan alam dan hutan Indonesia.
* **Warna Aksen (Accent)**: `Gold` (`#D4AF37`) - Melambangkan kemuliaan, kejayaan, dan warisan budaya yang berharga.
* **Warna Latar (Background)**: `Soft Light Green` (`#F4F7F5`) - Latar bersih yang teduh dan nyaman di mata untuk membaca artikel panjang.
* **Tipografi**: Menggunakan kombinasi font Google Fonts **Lora** (untuk kesan klasik/elegan pada judul dan nama rumah) serta **Manrope/Poppins** (untuk keterbacaan tinggi pada isi teks dan navigasi).

---

## Struktur Folder Proyek (Architecture)

Struktur direktori di dalam `lib/` disusun secara modular berdasarkan fungsinya:

```
lib/
├── main.dart                      # Entry point aplikasi & konfigurasi tema
├── app_colors.dart                # Palet warna global aplikasi (Forest Green & Gold)
├── splash_screen.dart             # Layar pembuka & pengecekan sesi login
├── login_screen.dart              # Halaman Login Firebase Auth
├── register_screen.dart           # Halaman Registrasi Pengguna Baru
├── forgot_password_screen.dart    # Halaman Lupa Password
├── home_screen.dart               # Beranda utama (Bottom Navigation Controller & Explore Tab)
├── regions_screen.dart            # Halaman Peta Indonesia Interaktif (SVG + Pulsing Pin)
├── house_detail_screen.dart       # Halaman detail rumah adat, filosofi, & fakta menarik
├── quiz_menu_screen.dart          # Halaman menu pemilihan kategori kuis & papan skor
├── quiz_confirmation_screen.dart  # Layar konfirmasi kuis sebelum bermain (NEW)
├── quiz_screen.dart               # Layar permainan kuis interaktif (Timer, Skor, Soal)
├── library_screen.dart            # Halaman daftar rumah adat favorit pengguna (Koleksi)
├── feedback_screen.dart           # Halaman saran dan masukan pengguna (Feedback) (NEW)
├── profile_screen.dart            # Halaman profil, progres XP, & koleksi lencana (badge)
├── settings_screen.dart           # Halaman pengaturan akun (edit nama, info app, hapus akun)
│
├── constants/
│   └── app_avatars.dart           # Daftar aset & nama untuk avatar profil pengguna
│
├── models/
│   └── quiz_question.dart         # Model representasi data soal kuis
│
├── services/
│   └── firestore_seeder.dart      # Alat bantu seeding awal data rumah & kuis ke Firestore
│
├── theme/
│   └── app_text_styles.dart       # Pengaturan gaya teks global menggunakan Google Fonts (Lora & Manrope)
│
└── widgets/
    └── house_card.dart            # Komponen kartu rumah adat reusable
```

---

## Desain Database Firestore

Aplikasi ini menggunakan **Cloud Firestore** sebagai database NoSQL dengan struktur koleksi sebagai berikut:

### 1. Koleksi `users`
Menyimpan profil dasar, tingkat level, XP, dan daftar pencapaian lencana (badges) pengguna.
```json
{
  "name": "Nama Pengguna",
  "avatarId": "avatar_1",
  "xp": 150,
  "level": 2,
  "badges": ["First Quiz", "Explorer Sumatera"],
  "featuredBadge": "First Quiz"
}
```
* **Sub-koleksi `users/{uid}/favorites`**: Menyimpan daftar rumah adat favorit yang ditandai oleh user. Dokumen di dalam sub-koleksi ini menyimpan ID rumah adat dari koleksi induk `houses` dan diurutkan berdasarkan timestamp penambahan.

### 2. Koleksi `houses`
Menyimpan seluruh katalog informasi rumah adat se-Nusantara.
```json
{
  "title": "Rumah Gadang",
  "category": "Sumatera",
  "location": "Sumatera Barat",
  "description": "Rumah adat khas Minangkabau...",
  "imageUrl": "https://url-gambar.com/gadang.jpg"
}
```

### 3. Koleksi `kuis_soal`
Menyimpan bank soal kuis pilihan ganda yang difilter berdasarkan wilayah.
```json
{
  "region": "Sumatera",
  "questionText": "Bagian atap berbentuk tanduk kerbau (gonjong) merupakan ciri khas dari...",
  "options": [
    "Rumah Gadang",
    "Rumah Joglo",
    "Rumah Honai",
    "Rumah Limas"
  ],
  "correctAnswerIndex": 0
}
```

### 4. Koleksi `users_score`
Menyimpan riwayat nilai tertinggi kuis dari setiap pengguna untuk ditampilkan di menu kuis.
```json
{
  "userId": "firebase_auth_uid",
  "score": 100
}
```

## Kontributor / Informasi Akademik
Proyek ini dibuat untuk memenuhi Ujian Akhir Semester (UAS) pada mata kuliah Pemrograman Mobile.

* **Nama Lengkap**: Achmad Satrio
* **Program Studi**: Teknologi Rekayasa Multimedia
* **Dosen Pengampu**: YUYUN KHAIRUNISA S.Si., M.Kom

---
*Selamat belajar dan melestarikan budaya bangsa melalui **Griya Nusantara**!* 🏛️🇮🇩
