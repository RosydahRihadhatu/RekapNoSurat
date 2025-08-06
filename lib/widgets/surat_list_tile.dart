import 'package:flutter/material.dart';
import 'package:nobook/theme/app_colors.dart';
import '../models/surat_model.dart';
import '../screens/detail_screen.dart';
import '../utils/date_formatter.dart';

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Garis warna vertikal
            Container(
              width: 6,
              height: 60,
              decoration: BoxDecoration(
                color:
                    surat.isMasuk
                        ? AppColors.masukColor
                        : AppColors.keluarColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),

            // Konten isi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor surat
                  Text(
                    formattedNomor,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),

                  // Perihal
                  Text(
                    surat.perihal,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          surat.isMasuk
                              ? AppColors.masukColor
                              : AppColors.keluarColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Tanggal di kanan bawah
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormatter.format(surat.tanggal),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
