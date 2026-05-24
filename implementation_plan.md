# Implementasi Desain Responsive (Phase 7, Phase 6, Phase 8)

Melanjutkan pekerjaan responsivitas UI aplikasi Griya Nusantara dengan memprioritaskan Phase 7 (Profile & Settings), dilanjutkan Phase 6 (Quiz Screen), dan terakhir Phase 8 (Verifikasi & Cleanup) sesuai instruksi pengguna.

## User Review Required

> [!NOTE]
> Semua sizing pada text, padding, margin, dan icon akan dikonversi menggunakan ekstensi `.sw`, `.sh`, dan `.sf` dari `ResponsiveHelper` agar skala UI konsisten dan proporsional di berbagai jenis layar (small, medium, large, tablet).

> [!IMPORTANT]
> - `profile_screen.dart` dan `settings_screen.dart` akan dimodifikasi dengan menginisialisasi `ResponsiveHelper.init(context)` di awal build method.
> - `badge_utils.dart` yang digunakan bersama oleh profile dan quiz screen juga akan dikonversi ke responsive design agar badge chip/dialog terlihat proporsional.
> - `quiz_screen.dart` akan di-refactor: menghapus ~1200 baris dummy data lokal kuis dan langsung mengambil data kuis dari `kDummyQuizQuestions` yang diimpor dari `dummy_quiz_questions.dart` bila Firebase kosong.

## Open Questions

Tidak ada pertanyaan terbuka yang mendesak untuk rencana ini, karena target dan referensi kode dari percakapan sebelumnya sudah cukup jelas dan disetujui.

---

## Proposed Changes

### Component: Gamification & Profile (Phase 7)

Menerapkan responsive layout pada halaman profil, pengaturan, dan komponen badge yang digunakan.

#### [MODIFY] [profile_screen.dart](file:///c:/Users/Satrio/Griya-Nusantara/lib/profile_screen.dart)
- Inisialisasi `ResponsiveHelper.init(context)` pada method `build`.
- Mengubah padding, margin, `SizedBox` spacing, font sizes, avatar radius (`52.sw`), dan icon sizes menggunakan unit responsif `.sw`, `.sh`, dan `.sf`.
- Menyesuaikan `crossAxisCount` pada grid picker avatar secara dinamis (4 kolom untuk handphone, 5 kolom untuk tablet) menggunakan `ResponsiveHelper.width >= 600 ? 5 : 4`.

#### [MODIFY] [settings_screen.dart](file:///c:/Users/Satrio/Griya-Nusantara/lib/settings_screen.dart)
- Inisialisasi `ResponsiveHelper.init(context)` pada method `build`.
- Mengubah padding list item, card spacing, dialog size/padding, input form size, dan font sizes (`AppTextStyles.copyWith(...)`) menggunakan unit responsif.

#### [MODIFY] [badge_utils.dart](file:///c:/Users/Satrio/Griya-Nusantara/lib/utils/badge_utils.dart)
- Menyesuaikan widget `buildBadgeChip` dan dialog info `showInfoDialog` agar menggunakan unit responsif `.sw`, `.sh`, dan `.sf` untuk text size, icon size, padding, dan constraint lebar maksimal.

---

### Component: Quiz Screen (Phase 6)

Merapikan kode quiz screen dengan memindahkan dummy data kuis dan menyelaraskan layout responsif.

#### [MODIFY] [quiz_screen.dart](file:///c:/Users/Satrio/Griya-Nusantara/lib/quiz_screen.dart)
- Inisialisasi `ResponsiveHelper.init(context)` pada method `build`.
- Menghapus list dummy data raksasa (~1200 baris) di dalam method `_loadDummyData()`.
- Mengubah method `_loadDummyData()` agar menggunakan data dari konstanta global `kDummyQuizQuestions` (diimpor dari `dummy_quiz_questions.dart`).
- Mengubah seluruh padding, font size, SizedBox height/width, progress indicator size, image height, border width, dan result dialog size ke unit responsif.

---

### Component: Verification & Cleanup (Phase 8)

#### [MODIFY] [task.md](file:///C:/Users/Satrio/.gemini/antigravity-ide/brain/457f7120-35b2-4eac-9f3f-8b60a07c8aa6/task.md)
- Memperbarui daftar ceklis task untuk memantau progress pekerjaan sesuai urutan Phase 7 -> Phase 6 -> Phase 8.

---

## Verification Plan

### Automated Tests
- Menjalankan `flutter analyze` untuk memastikan tidak ada kesalahan sintaksis atau error analisis.
- Menjalankan `flutter build apk --debug` untuk memverifikasi proses build berjalan lancar setelah perubahan selesai.

### Manual Verification
- Melakukan pemeriksaan visual pada layout halaman Profile, Settings, dan Quiz untuk memastikan tidak ada horizontal overflow atau text clipping di berbagai rasio layar emulator.
