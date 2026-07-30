/// Format tanggal & hitung mundur deadline — semua Bahasa Indonesia.
/// Dipakai TaskCard, Detail Task, Form Task, dan header Dashboard.
class DateFormatter {
  DateFormatter._();

  static const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  /// "Selasa, 29 Juli 2026"
  static String full(DateTime date) =>
      '${_hari[date.weekday - 1]}, ${date.day} ${_bulan[date.month - 1]} ${date.year}';

  /// "29 Jul 2026"
  static String short(DateTime date) =>
      '${date.day} ${_bulan[date.month - 1].substring(0, 3)} ${date.year}';

  /// "Sel, 29 Jul 2026 · 23:59" — kartu deadline di Detail Task.
  static String shortWithTime(DateTime date) =>
      '${_hari[date.weekday - 1].substring(0, 3)}, ${date.day} '
      '${_bulan[date.month - 1].substring(0, 3)} ${date.year} · '
      '${_twoDigit(date.hour)}:${_twoDigit(date.minute)}';

  /// "12 Agustus 2026, 23:59" — field Deadline di form Tambah/Edit Task.
  static String fullWithTime(DateTime date) =>
      '${date.day} ${_bulan[date.month - 1]} ${date.year}, '
      '${_twoDigit(date.hour)}:${_twoDigit(date.minute)}';

  /// "Hari ini" / "Besok" / "3 hari lagi" / "Terlewat"
  static String countdown(DateTime deadline) {
    final diff = _dateOnly(deadline).difference(_dateOnly(DateTime.now())).inDays;
    if (diff < 0) return 'Terlewat';
    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Besok';
    return '$diff hari lagi';
  }

  static bool isOverdue(DateTime deadline, {required bool isDone}) {
    if (isDone) return false;
    return _dateOnly(deadline).isBefore(_dateOnly(DateTime.now()));
  }

  static bool isToday(DateTime deadline) => _dateOnly(deadline) == _dateOnly(DateTime.now());

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  static String _twoDigit(int n) => n.toString().padLeft(2, '0');
}