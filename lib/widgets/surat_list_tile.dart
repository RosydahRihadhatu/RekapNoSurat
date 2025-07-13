import 'package:flutter/material.dart';
import '../models/surat_model.dart';
import '../screens/detail_screen.dart';

class SuratListTile extends StatelessWidget {
  final SuratModel surat;
  const SuratListTile({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: surat.isMasuk ? Colors.pink[50] : Colors.blue[50],
      title: Text(
        surat.perihal,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${surat.nomor} • ${surat.tanggal}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(surat: surat)),
        );
      },
    );
  }
}
