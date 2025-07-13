import 'package:flutter/material.dart';
import '../models/surat_model.dart';
import '../database/surat_dao.dart';
import 'form_screen.dart';
import '../widgets/confirm_delete_dialog.dart'; // Tambahan import

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
    final confirm = await showConfirmDeleteDialog(
      context,
    ); // Ganti dengan dialog custom
    if (confirm == true) {
      await SuratDao().deleteSurat(surat.id!);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Widget _buildItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Surat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildItem('Nomor', surat.nomor),
            _buildItem('Tanggal', surat.tanggal),
            _buildItem('Tipe', surat.tipe),
            _buildItem('Kategori', surat.kategori),
            _buildItem('Perihal', surat.perihal),
            surat.isMasuk
                ? _buildItem('Asal', surat.asal)
                : _buildItem('Tujuan', surat.tujuan),
            _buildItem('Keterangan', surat.keterangan),
            _buildItem('Bulan', surat.bulanRomawi),
            _buildItem('Tahun', surat.tahun),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _edit(context),
                  child: const Text('EDIT'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => _hapus(context),
                  child: const Text('HAPUS'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
