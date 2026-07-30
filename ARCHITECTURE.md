# ARCHITECTURE — Student Planner

## Aturan paling penting

UI nggak pernah tahu backend-nya Firebase. Titik.

`firebase_auth` dan `cloud_firestore` cuma boleh di-import di folder `data/`. Screen manggil Provider, Provider manggil Repository, Repository baru manggil Firebase. Nggak ada yang boleh loncat level.

Kenapa segitu ketatnya? Karena kalau suatu hari backend-nya diganti — misalnya pindah ke Supabase — yang perlu diubah cuma file di `data/repositories/`. Nggak ada satu screen pun yang perlu disentuh.

## Lapisan

```
Presentation (screens & widgets)
        ↓ context.watch / context.read
Providers (state, logic)
        ↓ manggil method abstract
Data (repositories & models)
        ↓
Firebase (Auth + Firestore)
```

Panahnya cuma boleh ke bawah. Layer bawah nggak pernah tahu ada layer di atasnya.

## Struktur folder

```
lib/
├── main.dart
├── firebase_options.dart        ← auto-generate, jangan diedit manual
├── core/
│   ├── theme/        app_colors.dart, app_text_styles.dart, app_theme.dart
│   ├── utils/         validators.dart, date_formatter.dart, firebase_error_mapper.dart
│   └── widgets/       tombol, text field, empty state, loading — semua reusable
├── data/
│   ├── models/        user_model.dart, task_model.dart
│   └── repositories/   auth_repository.dart, task_repository.dart
├── providers/
│   ├── auth_provider.dart
│   └── task_provider.dart
└── presentation/
    ├── routes/
    └── screens/
        ├── auth_gate.dart
        ├── splash_screen.dart
        ├── main_shell.dart
        ├── auth/       login, register, forgot_password
        ├── home/
        ├── tasks/      list, form (add & edit jadi satu file), detail
        └── profile/    profile, edit_profile, change_password, about
```

`TaskFormScreen` sengaja satu file buat Add dan Edit sekaligus — isinya 95% sama, bedanya cuma form kosong vs udah keisi, dan create() vs update(). Dibedain lewat satu parameter: `TaskFormScreen({TaskModel? task})`, null berarti mode tambah.

## Alur baca data

```
Firestore snapshots()
  → TaskRepository.watchTasks(uid)
    → TaskProvider nyimpen di _allTasks
      → getter: filteredTasks, totalTasks, dueToday, dueTomorrow, upcoming5
        → HomeScreen & TasksScreen
```

Cuma ada satu stream buat seluruh aplikasi. Dashboard dan halaman Tasks baca dari sumber yang sama, statistiknya dihitung di Provider dari list itu, bukan lewat query Firestore terpisah. Ini hemat biaya baca dan bikin dashboard sama daftar tugas nggak mungkin beda angka.

Selain stream, ada juga `refresh()` yang manggil query sekali (bukan stream) — dipanggil otomatis tiap habis create/update/delete/toggle status, sama lewat tombol refresh manual. Ini jaring pengaman kalau live listener-nya lagi kurang responsif di jaringan tertentu, jadi user nggak perlu logout-login cuma buat lihat data terbaru.

## Alur nulis data

```
Tombol Simpan ditekan
  → Provider set loading, notifyListeners
    → Repository nulis ke Firestore
      → stream nangkep perubahan otomatis
        → UI berubah sendiri
      → refresh() dipanggil juga sebagai jaring pengaman
```

Item nggak pernah ditambahin manual ke list setelah nyimpen — biarin stream/refresh yang ngurusin, biar nggak ada resiko data ke-duplikat. Tombol dikunci selama proses jalan biar nggak ke-tap dua kali.

## Search & filter

Semuanya kerja di memori, bukan query ke Firestore:

```dart
List<TaskModel> get filteredTasks {
  final q = _searchQuery.toLowerCase().trim();
  return _allTasks.where((t) {
    final cocokStatus = ...;
    final cocokQuery = q.isEmpty || t.title.toLowerCase().contains(q) || t.course.toLowerCase().contains(q);
    return cocokStatus && cocokQuery;
  }).toList();
}
```

Firestore nggak punya full-text search asli. Query pakai `>=`/`<=` cuma cocok buat prefix satu field doang. Untuk jumlah tugas per user yang wajar (puluhan sampai ratusan), filter di klien lebih cepet dan lebih akurat, tanpa nambah biaya baca. Kalau suatu saat datanya udah ratusan-ribuan per user, baru perlu mikir ulang pendekatan ini.

## Auth flow

`AuthGate` itu `StreamBuilder` yang dengerin `authStateChanges()` — user null tampilin Login, ada isinya tampilin MainShell. Satu-satunya sumber kebenaran adalah Firebase Auth sendiri, jadi logout dari mana aja (halaman profil, token expired, dll) otomatis lempar balik ke Login tanpa perlu navigasi manual di banyak tempat.

Yang agak beda dari kebiasaan: setelah register berhasil, user **sengaja di-signOut lagi** dan diarahin balik ke Login, bukan langsung masuk aplikasi. Ini butuh trik tambahan — soalnya createUserWithEmailAndPassword() otomatis bikin user login sesaat sebelum di-signOut, dan kalau nggak dijaga, AuthGate bisa sempet nampilin MainShell sekilas sebelum balik ke Login. Makanya ada flag `_isRegistering` di AuthProvider yang bikin perubahan status auth selama proses register itu diabaikan dulu, sampai prosesnya beneran kelar.

Ganti password juga ada aturan khusus dari Firebase sendiri: kalau sesi udah agak lama, `updatePassword()` bakal ditolak sampai user re-autentikasi ulang pakai password lama. Makanya form ganti password selalu minta password lama duluan.

## State management

Dua `ChangeNotifier`: `AuthProvider` nyimpen user aktif & profil, `TaskProvider` nyimpen daftar tugas plus search/filter/statistik. `TaskProvider` gantung ke `AuthProvider` (butuh uid), makanya dipasang pakai `ChangeNotifierProxyProvider`.

Aturan pemakaian yang sering ketuker: `context.watch` buat nampilin data yang berubah-ubah di dalam `build()`, `context.read` buat manggil aksi di dalam `onPressed`. Kebalik dari itu bakal bikin UI nggak update atau malah rebuild sia-sia terus-terusan.

## Error handling

Repository yang throw exception, Provider yang nangkep dan ubah jadi kalimat Indonesia (lewat `firebase_error_mapper.dart`), UI tinggal nampilin. Screen nggak pernah nangkep `FirebaseException` langsung — biar semua terjemahan error ada di satu tempat aja dan konsisten di seluruh aplikasi.
