import 'package:flutter/material.dart';
import '../models/surat_model.dart';
import '../screens/detail_screen.dart';
import '../database/surat_dao.dart';

class SuratListTile extends StatelessWidget {
  final SuratModel surat;
  final VoidCallback onRefresh;

  const SuratListTile({
    super.key,
    required this.surat,
    required this.onRefresh,
  });

  String get formattedNomor {
    if (surat.isMasuk) {
      return surat.nomor;
    } else {
      final tipeSingkat =
          (surat.tipe?.toLowerCase() ?? '') == 'bersama' ? 'B' : 'P';
      return '${surat.nomor}/II.03.AU/06.04/$tipeSingkat/${surat.kategori}/${surat.bulanRomawi}/${surat.tahun}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(surat: surat)),
        ).then((value) {
          // Refresh jika kembali dari detail
          onRefresh();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: surat.isMasuk ? Colors.pink : Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    formattedNomor,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                surat.perihal,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _formatTanggal(surat.tanggal),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTanggal(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final bulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}
