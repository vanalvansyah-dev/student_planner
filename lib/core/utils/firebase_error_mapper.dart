/// Pemetaan kode error Firebase Auth ke kalimat Bahasa Indonesia.
/// Provider selalu lewat fungsi ini — UI tidak pernah melihat kode mentah.
String mapAuthError(String code) {
  switch (code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Email atau password salah.';
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'email-already-in-use':
      return 'Email ini sudah terdaftar. Coba masuk.';
    case 'weak-password':
      return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
    case 'user-disabled':
      return 'Akun ini telah dinonaktifkan.';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Coba lagi beberapa saat lagi.';
    case 'network-request-failed':
      return 'Tidak ada koneksi internet. Periksa jaringanmu.';
    case 'requires-recent-login':
      return 'Sesi kamu sudah lama. Silakan login ulang untuk melanjutkan.';
    default:
      return 'Terjadi kesalahan. Coba lagi.';
  }
}