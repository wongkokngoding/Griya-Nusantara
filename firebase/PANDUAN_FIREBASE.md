# Panduan Aturan Firebase — Griya Nusantara

## Yang perlu di Firebase

| Layanan | Fungsi |
|---------|--------|
| **Firestore** | Simpan `avatarId` + data user di `users/{uid}` |

**Firebase Storage tidak diperlukan** untuk fitur avatar (avatar bawaan di aplikasi).

---

## 1. Firestore Rules

1. Buka [Firebase Console](https://console.firebase.google.com) → pilih project Anda
2. **Build** → **Firestore Database** → tab **Rules**
3. Salin seluruh isi file `firebase/firestore.rules`
4. Klik **Publish**

### Field `avatarId` di dokumen user

Contoh struktur dokumen `users/{uid}`:

```json
{
  "uid": "abc123",
  "name": "Satrio",
  "email": "user@email.com",
  "xp": 0,
  "level": 1,
  "badges": [],
  "avatarId": "penjelajah",
  "quizAttempts": 0,
  "lastScore": 0,
  "createdAt": "..."
}
```

**Nilai `avatarId` yang valid** (pilih salah satu):

| avatarId | Label |
|----------|--------|
| `penjelajah` | Penjelajah (default) |
| `pakar` | Pakar Budaya |
| `pengrajin` | Pengrajin |
| `penjaga` | Penjaga Adat |
| `pahlawan` | Pahlawan |
| `alam` | Penjaga Alam |
| `warisan` | Warisan |
| `legenda` | Legenda |

User memilih avatar lewat aplikasi; field ini di-update otomatis.

---

## 2. Deploy lewat CLI (opsional)

```bash
cd "d:\TUGAS\CODING\MDI\UAS\Coding flutter\griyanusantara\firebase"
firebase deploy --only firestore:rules
```

---

## Ringkasan izin

| Path | Baca | Tulis |
|------|------|-------|
| `users/{uid}` | User login | Hanya pemilik dokumen |
| `users/{uid}/favorites/*` | Pemilik | Pemilik |
| `users_score/*` | User login | Create (userId = diri sendiri) |
| `houses/*` | User login | ❌ |
| `kuis_soal/*` | User login | ❌ |
