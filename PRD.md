# PRD — Student Planner

## Kenapa aplikasi ini dibuat

Tugas kuliah biasanya numpuk di tempat yang beda-beda — grup WhatsApp, catatan kertas, notes HP, atau cuma diinget-inget aja. Ujung-ujungnya ada yang kelewat. Student Planner nyoba nyelesain itu dengan satu tempat doang: catat tugasnya, kasih deadline, terus dashboard yang langsung jawab "hari ini aku harus ngerjain apa?"

Cuma ada satu jenis user, mahasiswa, dan tiap orang cuma bisa lihat tugas dia sendiri. Nggak ada peran admin, nggak ada fitur share tugas ke orang lain.

## Halaman

Tujuh halaman: Login, Register, Home, Tasks, Add/Edit Task, Detail Task, Profile. Masing-masing punya satu tugas jelas — Home buat liat ringkasan cepet, Tasks buat nyari & ngatur semua tugas, dan seterusnya. Nggak ada halaman yang isinya campur aduk.

## Yang wajib ada

**Register** — isi username, email, password, konfirmasi password. Password minimal 6 karakter (batas bawaan Firebase Auth). Kalau emailnya udah kepake, kasih tau "Email ini sudah terdaftar. Coba masuk." Setelah berhasil daftar, balikin ke halaman Login, bukan langsung masuk ke aplikasi — biar user sadar akunnya beneran udah jadi.

**Login** — kalau salah email/password, pesannya digabung jadi satu ("Email atau password salah") biar nggak ketauan mana yang salah. Ini standar keamanan biasa, bukan sok misterius.

**Sesi tersimpan** — buka aplikasi lagi, kalau sebelumnya udah login, langsung ke Dashboard tanpa isi form lagi.

**Tambah tugas** — judul, mata kuliah, deadline, prioritas wajib diisi. Deskripsi opsional. Deadline dipilih lewat date picker + time picker, disimpan sebagai Timestamp (bukan teks). Status awal selalu "belum selesai".

**Lihat tugas** — list-nya otomatis keurut dari deadline paling deket. Tiap kartu nunjukin judul, mata kuliah, sisa waktu, warna prioritas, status. Kalau belum ada tugas sama sekali, munculin ajakan buat nambah yang pertama.

**Hapus tugas** — selalu lewat dialog konfirmasi dulu. Sekali hapus, hilang beneran, nggak ada undo.

**Search** — jalan pas lagi ngetik, nggak perlu tombol cari. Nyari di judul dan mata kuliah, nggak peduli huruf besar kecil. Kalau nggak ketemu, kasih tau "Tidak ada tugas yang cocok."

**Dashboard** — urutannya: sapaan "Halo, {username}", total tugas, deadline hari ini, yang udah selesai, yang belum, terus 5 deadline terdekat (cuma yang belum selesai, diurutin naik). Semua angka ini dihitung dari data yang sama dengan halaman Tasks, jadi nggak mungkin beda.

**Ganti password** — minta password lama, baru, konfirmasi. Wajib login ulang secara internal (re-autentikasi) dulu sebelum bisa ganti — kalau password lama salah, langsung kasih tau.

## Yang sengaja nggak dibikin di v1.0

Upload foto profil (nggak pakai Firebase Storage sama sekali), notifikasi push, mode offline yang beneran dirancang, sub-tugas, kalender bulanan, share tugas ke user lain, dark mode. Kalau nanti dari daftar ini ada yang perlu ditambah, catat sebagai versi berikutnya, jangan diam-diam nambah tanpa dicatat.

## Aturan yang harus selalu dipegang

Satu tugas cuma bisa dibaca, diubah, dihapus sama pemiliknya — ini dijamin di level Firestore Rules, bukan cuma di kode aplikasi. `userId` selalu diisi otomatis dari sistem, nggak pernah dari input user. Deadline boleh di masa lalu (tugas telat tetap valid, ditandain "Terlewat"). Prioritas cuma boleh low/medium/high, status cuma pending/done. `createdAt` selalu diisi dari server, bukan dari jam HP — biar nggak bisa dimanipulasi.

## Kapan dianggap "selesai"

Kalau alurnya udah jalan mulus di HP beneran (bukan cuma emulator), errornya ditangani dengan pesan yang bisa dimengerti, ada loading pas lagi proses, nggak ada `print()` nyangkut di kode, dan udah masuk GitHub dengan commit message yang jelas.
