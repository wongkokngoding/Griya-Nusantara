# LAPORAN PENGEMBANGAN APLIKASI MEDIA DIGITAL INTERAKTIF "GRIYA NUSANTARA" SEBAGAI SARANA EDUKASI RUMAH ADAT TRADISIONAL INDONESIA BERBASIS FLUTTER

**Diajukan Sebagai Salah Satu Tugas Mata Kuliah Media Digital Interaktif**

**Disusun Oleh:**
* Achmad Satrio (NIM: 2490343001)

**Dosen Pengampu:**
* Yuyun Khairunisa S.Si., M.Kom

**PROGRAM STUDI TEKNOLOGI REKAYASA MULTIMEDIA**  
**JURUSAN DESAIN**  
**POLITEKNIK NEGERI MEDIA KREATIF**  
**JAKARTA 2026**

---

## DAFTAR ISI
*(Daftar Isi dapat disesuaikan)*

## DAFTAR GAMBAR
*(Daftar Gambar dapat disesuaikan)*

---

### 1. Identitas Mahasiswa
* **Program Studi**: Teknologi Rekayasa Multimedia
* **Nama**: Achmad Satrio
* **NIM**: 2490343001

### 2. Nama Aplikasi
**Griya Nusantara**

### 3. Latar Belakang
Indonesia memiliki kekayaan arsitektur tradisional yang sangat beragam, mulai dari Sabang hingga Merauke. Sayangnya, pengetahuan generasi muda terhadap warisan budaya ini semakin menurun seiring perkembangan zaman. Banyak pelajar dan masyarakat umum yang tidak mengenal rumah adat dari daerah lain, apalagi memahami filosofi dan keunikan arsitekturnya.

Permasalahan utama yang ingin diselesaikan adalah minimnya media edukasi yang menyajikan informasi rumah adat Indonesia secara interaktif, menarik, dan mudah diakses melalui perangkat mobile. Media pembelajaran konvensional seperti buku teks cenderung statis dan kurang memotivasi pengguna untuk mengeksplorasi lebih jauh.

Aplikasi Griya Nusantara yang saya buat bisa menjadi solusi dengan menghadirkan platform edukasi berbasis Flutter yang menggabungkan penyajian materi visual rumah adat, peta interaktif Indonesia, serta fitur kuis gamifikasi untuk mengevaluasi dan meningkatkan pemahaman pengguna secara menyenangkan.

### 4. Tujuan Aplikasi
Berikut beberapa tujuan dari pembuatan aplikasi Griya Nusantara ini:
1. Menyediakan media pembelajaran interaktif yang menarik dan mudah digunakan untuk mengenalkan rumah adat di seluruh Indonesia.
2. Meningkatkan pengetahuan dan apresiasi pengguna terhadap kekayaan arsitektur tradisional nusantara.
3. Mengevaluasi pemahaman pengguna melalui fitur kuis interaktif dengan sistem gamifikasi (XP, Level, dan Badge).
4. Membangun platform edukasi mobile berbasis Flutter yang dapat diakses kapan saja dan di mana saja.

### 5. Deskripsi Umum
Griya Nusantara adalah aplikasi edukasi berbasis mobile yang dibangun menggunakan framework Flutter. Aplikasi ini menyajikan informasi mengenai rumah adat dari 5 pulau besar di Indonesia: Sumatera, Jawa, Kalimantan, Sulawesi, dan Papua.

Pengguna dapat menjelajahi rumah adat melalui beranda interaktif, peta SVG Indonesia yang bisa diklik per pulau, membaca materi detail (filosofi, arsitektur, dan fakta menarik), menyimpan rumah adat favorit, serta mengerjakan kuis pilihan ganda per wilayah. Setiap aktivitas kuis memberikan XP yang terakumulasi untuk menaikkan level dan mendapatkan badge penghargaan.

### 6. Fitur Utama
Aplikasi ini memiliki beberapa fitur utama, antara lain:

* **a. Splash Screen**  
  Halaman pembuka dengan logo aplikasi, animasi fade-in, dan pengecekan status autentikasi pengguna secara otomatis.
* **b. Halaman Beranda**  
  Halaman beranda ini menampilkan sapaan personal secara real-time dengan mengambil nama pengguna dari Firestore menggunakan StreamBuilder. Untuk mempermudah pencarian rumah adat berdasarkan nama, provinsi, atau pulau, tersedia search bar yang dilengkapi dengan fitur debounce. Saat pertama kali dibuka, aplikasi akan menyajikan daftar rumah adat populer sebagai konten default, di mana setiap kartu rumah adatnya dikemas menarik dengan menyertakan gambar, judul, lokasi, serta deskripsi singkat.
* **c. Halaman Daerah Peta Interaktif**  
  Pada halaman ini aplikasi menyediakan peta SVG Indonesia interaktif dengan animasi pulse pin di 5 pulau utama yang dapat diketuk pengguna. Memilih pulau akan memunculkan kartu aksi dengan tombol "Jelajahi" untuk membuka bottom sheet berisi daftar rumah adat wilayah tersebut. Sebagai alternatif navigasi yang estetik, terdapat juga shortcut button dengan bento layout di bawah peta.
* **d. Halaman Detail Rumah Adat**  
  Halaman ini menampilkan Hero Image beranimasi transisi serta informasi lokasi dan pulau dalam bentuk chip badge. Informasi detail disajikan melalui deskripsi lengkap Filosofi & Arsitektur, ditambah kartu Fakta Menarik berwarna yang diambil dari Firestore (dengan fallback data lokal). Pengguna juga dapat mengelola koleksi melalui tombol Favorit yang tersinkronisasi ke Firestore, serta mengakses tombol Tes Kuis per wilayah di bagian bawah layar.
* **e. Halaman Menu Kuis**  
  Pada halaman menu kuis ini akan menampilkan total poin pengguna dari Firestore serta menyediakan 6 kategori kuis (Acak/Nusantara dan 5 wilayah utama) yang dilengkapi ikon, warna, deskripsi unik, dan dialog konfirmasi sebelum memulai.
* **f. Halaman Kuis**  
  Di halaman kuis menyajikan soal pilihan ganda (4 opsi) dengan progress bar, skor real-time, serta animasi fade & slide saat pergantian soal. Dilengkapi feedback banner (hijau/merah) berjeda 1,8 detik, serta dialog hasil akhir yang merangkum persentase skor, level, XP, badge, dan opsi "Coba Lagi".
* **g. Halaman Koleksi Favorit**  
  Menampilkan daftar rumah adat yang di-bookmark pengguna secara real-time dari subcollection Firestore (`favorites`), di mana setiap kartu dapat diklik untuk membuka halaman detail.
* **h. Halaman Profil**  
  Di halaman profil akan memuat kustomisasi profil dengan 8+ pilihan avatar SVG dari Firestore, nama, gelar level, dan pajangan badge pilihan. Halaman ini juga dilengkapi kartu progres (Level, XP, progress bar) serta akses ke menu pengaturan dan tombol logout.
* **i. Halaman Pengaturan**  
  Halaman pengaturan dapat diakses dari halaman profil. Di sini terdapat fitur edit nama pengguna dengan dialog validasi, informasi email akun, detail "Tentang Aplikasi" (nama, versi, deskripsi), opsi penghapusan akun secara permanen dari Firebase Auth dan Firestore, serta akses ke menu Saran dan Masukan.
* **j. Halaman Saran dan Masukan (User Feedback)**  
  Halaman feedback yang berada di dalam menu pengaturan ini memungkinkan pengguna mengirimkan saran atau masukan terkait aplikasi. Nama pengguna dan email terisi secara otomatis dengan mengambil data pengguna aktif dari Firebase Authentication/Firestore. Setiap masukan yang dikirimkan akan disimpan langsung secara real-time ke Firestore pada koleksi `feedbacks` untuk keperluan evaluasi pengembangan.
* **k. Sistem Gamifikasi**  
  Sistem XP, Level, dan Badge yang terintegrasi penuh:
  
  | Level | Gelar | XP Minimum |
  | :---: | :--- | :---: |
  | 1 | Penjelajah Budaya | 0 |
  | 2 | Pakar Daerah | 200 |
  | 3 | Nusantara Explorer | 500 |
  | 4 | Ahli Tradisi | 900 |
  | 5 | Guru Warisan | 1500 |

  **Jenis Badge:**
  * **First Quiz**: Menyelesaikan kuis pertama
  * **Perfect Score**: Skor 100% dalam satu sesi
  * **Cultural Hero**: Skor ≥ 70% dalam satu sesi
  * **Master [Wilayah]**: Skor 100% pada kuis wilayah tertentu
  * **Explorer [Wilayah]**: Skor ≥ 40% pada kuis wilayah tertentu
  * **Level X Achieved**: Mencapai level tertentu

* **l. Tampilan Responsif**  
  Seluruh halaman menggunakan custom ResponsiveHelper (sw, sh, sf extensions) yang menyesuaikan ukuran widget, font, dan spacing secara proporsional terhadap dimensi layar perangkat.

### 7. Deskripsi Fitur Kuis
* **a. Jenis Soal**  
  Pilihan ganda dengan 4 opsi jawaban (A, B, C, D). Setiap sesi terdiri dari 10 soal yang dipilih secara acak dari database. Soal dikategorikan berdasarkan wilayah (Sumatera, Jawa, Kalimantan, Sulawesi, Papua) atau bisa dipilih secara acak (Nusantara).
* **b. Sumber Soal**  
  Soal diambil dari koleksi `kuis_soal` di Cloud Firestore. Jika koneksi gagal atau data belum tersedia, aplikasi menggunakan data dummy lokal (`dummy_quiz_questions.dart`) sebagai fallback agar kuis tetap berjalan.
* **c. Mekanisme Penilaian**  
  * Setiap jawaban benar menambah skor.
  * Skor akhir dihitung sebagai persentase: (jawaban benar / total soal) × 100.
  * Skor disimpan ke koleksi `users_score` di Firestore.
  * Skor juga dikonversi menjadi XP yang terakumulasi di profil pengguna dan menentukan level.
* **d. Feedback kepada Pengguna**  
  * **Feedback langsung (per soal)**: Setelah memilih jawaban, banner animasi akan muncul dan menunjukkan apakah jawaban benar (hijau, "Jawaban Benar! Hebat!") atau salah (merah, "Jawaban Salah! Jangan menyerah!"). Opsi yang dipilih berubah warna beserta icon ceklis atau silang.
  * **Feedback akhir (selesai kuis)**: Dialog hasil menampilkan skor dalam lingkaran persentase animasi, pesan motivasi bertingkat (Sempurna/Hebat/Lumayan/Jangan menyerah), statistik Level & XP, jumlah jawaban benar dan akurasi, serta badge baru yang diraih.
* **e. Navigasi Soal**  
  Soal berpindah secara otomatis setelah jeda ketika pengguna menjawab, dengan animasi agar transisi halus. Terdapat tombol back dengan dialog konfirmasi keluar agar progres tidak hilang secara tidak sengaja. Di akhir kuis, pengguna dapat memilih "Kembali ke Beranda" atau "Coba Lagi" (soal akan diacak ulang).

### 8. Teknologi Yang Digunakan
Dalam pengembangan aplikasi ini, menggunakan teknologi:
* **Flutter** (Framework utama)
* **Dart** (Bahasa pemrograman)
* **Firebase Authentication** (Sistem autentikasi pengguna login, register, lupa password, hapus akun)
* **Cloud Firestore** (Database NoSQL cloud untuk menyimpan data rumah adat, soal kuis, skor, profil pengguna, favorit, badge, avatar, dan data saran/masukan (feedback) dalam koleksi `feedbacks`)
* **Firebase Core** (Inisialisasi layanan Firebase)
* **Google Fonts** (Tipografi dinamis font Lora, Poppins, Manrope)

**Struktur Database**
*(Dapat dilengkapi dengan skema visual database)*

### 9. Desain dan UI/UX
Desain aplikasi ini menggabungkan nuansa alam Indonesia (hijau hutan, emas tradisional) dengan tata letak modern yang bersih dan rapi. Konsep ini dipilih agar aplikasi terasa premium namun tetap hangat dan relevan dengan tema budaya nusantara. Dengan palet warna seperti di bawah ini:
1. **Dark Green (#1B4332)**: digunakan sebagai warna utama tombol, header, dan navigasi aktif.
2. **Gold (#D4AF37)**: digunakan sebagai warna aksen emas skor, badge, dan ikon penghargaan.
3. **Deep Forest (#0D2119)**: digunakan di teks utama seperti judul dan heading.
4. **Grey Text (#708078)**: digunakan di teks sekunder seperti deskripsi dan subtitle.
5. **Border (#D1D9D4)**: digunakan sebagai garis pembatas dan outline card.
6. **Background (#F4F7F5)**: digunakan untuk latar belakang halaman aplikasi.

**Tipografi:**
* **Lora (Serif)**: Untuk heading dan judul, memberikan kesan elegan dan kultural.
* **Poppins (Sans-serif)**: Untuk body text dan deskripsi, memberikan keterbacaan yang baik.
* **Manrope (Sans-serif)**: Untuk elemen UI (label, tombol, form), memberikan kesan modern dan clean.

**Layout:**
Aplikasi menggunakan Bottom Navigation Bar 5 tab (Beranda, Daerah, Kuis, Koleksi, Profil) berbasis IndexedStack untuk menjaga state halaman tetap aktif. UI dikemas menggunakan card-based layout untuk informasi rumah adat, bento grid untuk shortcut pulau, serta bottom sheet untuk daftar wilayah. Seluruh tampilan dibungkus dengan SafeArea, SingleChildScrollView, dan ResponsiveHelper guna menjamin responsivitas yang adaptif di berbagai perangkat.

**Kemudahan Penggunaan:**
Aplikasi ini dibuat dengan beberapa fitur agar memudahkan user, antara lain:
* Navigasi intuitif dengan bottom navigation bar dan back button.
* Search bar dengan debounce untuk pencarian cepat.
* Dialog konfirmasi sebelum aksi penting (memulai kuis, keluar kuis, hapus akun).
* Feedback visual yang jelas (warna hijau/merah, ikon centang/silang, snackbar notifikasi).
* Validasi form pada seluruh input pengguna.

### 10. Alur Penggunaan Aplikasi
*(Dapat dilengkapi dengan flowchart alur penggunaan)*

### 11. Kelebihan Aplikasi
1. **Sistem Gamifikasi Imersif**: Memotivasi belajar melalui akumulasi XP, 5 tingkat level dengan gelar unik, serta 6+ jenis badge penghargaan yang tersinkronisasi secara real-time.
2. **Eksplorasi Peta Interaktif SVG**: Visualisasi peta Indonesia adaptif dengan animasi pulse pin untuk menjelajah rumah adat per pulau secara visual dan intuitif.
3. **Arsitektur Data Dinamis & Kompatibilitas CRUD**: Didukung penuh oleh Cloud Firestore untuk sinkronisasi data real-time (profil, avatar, favorit, kuis, feedback) sekaligus mendukung fitur offline-first menggunakan Fallback Data Lokal.
4. **Optimasi UX & Transisi Responsif**: Memadukan bento grid layout, responsive helper, dan animasi transisi halus yang menjaga performa aplikasi tetap ringan di berbagai perangkat.

### 12. Kekurangan Aplikasi
* **Ketergantungan Internet**: Materi utama (gambar dan deskripsi rumah adat) membutuhkan koneksi internet untuk dimuat dari Firestore dan URL gambar. Tanpa internet, hanya data dummy kuis yang tersedia.
* **Belum Ada Fitur Offline Caching**: Belum mengimplementasikan mekanisme cache lokal (misalnya Hive atau SQLite) untuk menyimpan data yang sudah pernah dimuat.
* **Belum Ada Fitur Multimedia Lanjutan**: Belum terdapat fitur video pembelajaran, audio narasi, atau model 3D/AR rumah adat.
* **Belum Ada Leaderboard Global**: Sistem gamifikasi masih bersifat individual — belum ada papan peringkat antar pengguna.
* **Belum Ada Dark Mode**: Aplikasi saat ini hanya mendukung tema terang (light mode).
* **Daerah masih terbatas**: Hanya tersedia 5 pulau besar Indonesia.

### 13. Metode Pengembangan
Pengembangan aplikasi Griya Nusantara menerapkan metode Agile melalui siklus pendek yang adaptif dan fokus pada evaluasi bertahap. Prosesnya dipadatkan ke dalam tiga tahapan utama:
* **Fase Pra-Pengembangan (Analisis & Desain)**: Mengidentifikasi kebutuhan fitur utama (edukasi dan kuis), fitur pendukung (backend, gamifikasi, feedback), serta merancang wireframe, palet warna, dan arsitektur navigasi UI/UX.
* **Fase Pengembangan Bertahap (Iterasi Fitur)**: Pengembangan dibagi ke dalam beberapa sprint pendek. Dimulai dari fondasi sistem (autentikasi dan konfigurasi Firebase), dilanjutkan ke fitur inti (beranda, peta SVG interaktif, detail rumah adat), hingga implementasi sistem gamifikasi (kuis, XP, leveling, profil pengguna) serta fitur feedback.
* **Fase Finalisasi (Polish & Pengujian)**: Optimalisasi komponen menggunakan responsive helper, penerapan animasi halus, penyediaan fallback data lokal untuk mode offline, serta pengujian menyeluruh guna memastikan stabilitas aplikasi.

### 14. Perancangan Fitur (UseCase Diagram)
*(Dapat dilengkapi dengan diagram UseCase)*

### 15. Perancangan Visual Desain
*(Dapat dilengkapi dengan screenshot/wireframe)*
