# Student Planner

Aplikasi mobile buat mahasiswa yang sering kewalahan ngatur tugas kuliah. Setiap tugas dicatat lengkap dengan mata kuliah, deadline, dan prioritas, terus dashboard-nya langsung kasih tahu apa yang harus dikerjain hari ini dan besok. Tiap akun datanya terpisah — punya siapa ya punya sendiri.

## Fiturnya

Login, register, sama lupa password sudah pakai Firebase Auth. Setelah daftar, sengaja diarahkan balik ke halaman login dulu (bukan langsung masuk) — biar user benar-benar tahu akunnya sudah jadi dan bisa login sendiri.

Dashboard-nya nampilin total tugas, berapa yang deadline hari ini, berapa besok, berapa yang sudah kelar, sama daftar 5 deadline terdekat. Semua kartu itu bacanya dari satu sumber data yang sama, jadi angkanya nggak bakal beda-beda sendiri.

Halaman Tugas ada search (ketik langsung ketemu, nggak perlu tombol cari), filter status, dan CRUD lengkap. Tiap kartu tugas punya strip warna di kiri sesuai prioritas dan chip yang nunjukin sisa waktu — "2 hari lagi", "Hari ini", atau "Terlewat".

Profil bisa ganti nama dan pilih warna tema sendiri (12 pilihan, setengahnya solid setengahnya gradasi) — warnanya kepakai di avatar, header dashboard, sampai ikon-ikon kartu statistik. Ganti password juga ada, wajib masukin password lama dulu sebelum bisa ganti.

## Stack

Flutter, Firebase Auth + Cloud Firestore, Provider buat state management. Arsitekturnya dipisah jadi beberapa layer — UI nggak pernah langsung manggil Firestore, semua lewat Repository. Nggak pakai SQLite atau Firebase Storage sama sekali.

## Struktur folder

```
lib/
├── main.dart
├── core/            → tema, warna, widget yang dipakai berulang
├── data/            → model & repository, satu-satunya yang boleh sentuh Firebase
├── providers/        → state management
└── presentation/     → semua screen
```

Kalau mau paham lebih detail kenapa disusun begini, baca `ARCHITECTURE.md`. Kalau lagi mau ubah sesuatu dan takut ngerusak bagian lain, cek `HANDOFF.md` dulu.

## Cara jalanin

```bash
git clone https://github.com/<username>/student_planner.git
cd student_planner
flutter pub get
flutterfire configure
```

`firebase_options.dart` sengaja nggak ikut ke-commit (lihat bagian bawah), jadi harus di-generate ulang pakai project Firebase kamu sendiri lewat `flutterfire configure` di atas.

Di Firebase Console, nyalain:
- Authentication → Email/Password
- Firestore Database (mode production)
- Firestore Rules — copy dari `SCHEMA.md`
- Firestore Index untuk collection `tasks`: `userId` + `deadline`, keduanya Ascending

Terus tinggal:
```bash
flutter run
```

Buat APK: `flutter build apk --release`, hasilnya ada di `build/app/outputs/flutter-apk/app-release.apk`.

## Soal keamanan

Isolasi data antar user itu dijamin di Security Rules Firestore, bukan cuma dari filter query di aplikasi — jadi walau ada bug di kode yang lupa filter, data orang lain tetap nggak bisa kebaca. File kredensial Firebase (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`) sengaja di-ignore dari repo ini, jangan ditambahin manual.

## Dokumen lain

- `PRD.md` — apa aja yang dibangun dan kenapa
- `ARCHITECTURE.md` — struktur kode & alur datanya

## Dibuat oleh

Gilang Ilham Alvansyah
