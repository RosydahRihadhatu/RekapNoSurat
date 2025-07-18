class DateFormatter {
  static String format(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final bulan = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}
