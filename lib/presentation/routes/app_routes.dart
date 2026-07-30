/// Nama rute terpusat. Login/Register/MainShell dikendalikan langsung oleh
/// AuthGate (bukan named route) — konstanta ini baru kepakai penuh mulai
/// Tahap 6 & 9 untuk rute yang dipanggil dari banyak tempat.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
}