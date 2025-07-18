import 'package:flutter/material.dart';
import '../models/surat_model.dart';
import '../database/surat_dao.dart';
import 'form_screen.dart';
import '../utils/date_formatter.dart';
import '../widgets/confirm_delete_dialog.dart';

class DetailScreen extends StatelessWidget {
  final SuratModel surat;
  const DetailScreen({super.key, required this.surat});

  void _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(isMasuk: surat.isMasuk, surat: surat),
      ),
    );
    if (context.mounted) Navigator.pop(context);
  }

  void _hapus(BuildContext context) async {
    final confirm = await showConfirmDeleteDialog(context);
    if (confirm == true) {
      await SuratDao().deleteSurat(surat.id!);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Widget _buildItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(value ?? '-', style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMasuk = surat.isMasuk;

    return Scaffold(
      backgroundColor:
          isMasuk ? const Color(0xFFFFECF5) : const Color(0xFFE7F2FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          isMasuk ? 'Detail Surat Masuk' : 'Detail Surat Keluar',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItem('Nomor', surat.nomor),
            _buildItem('Tanggal', DateFormatter.format(surat.tanggal)),
            if (!isMasuk) _buildItem('Tujuan', surat.tujuan),
            if (!isMasuk) _buildItem('Tipe', surat.tipe),
            if (!isMasuk) _buildItem('Kategori', surat.kategori),
            _buildItem('Perihal', surat.perihal),
            if (isMasuk) _buildItem('Asal', surat.asal),
            _buildItem('Keterangan', surat.keterangan),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _edit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'UBAH',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _hapus(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAD1457),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'HAPUS',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
