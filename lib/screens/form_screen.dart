import 'package:flutter/material.dart';
import '../models/surat_model.dart';
import '../database/surat_dao.dart';
import '../utils/date_utils.dart';

class FormScreen extends StatefulWidget {
  final bool isMasuk;
  final SuratModel? surat;

  const FormScreen({super.key, required this.isMasuk, this.surat});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final dao = SuratDao();

  final Map<String, String> kategoriOptions = {
    'Pedoman': 'PED',
    'Surat Keputusan': 'KEP',
    'Surat Edaran': 'EDR',
    'Surat Pernyataan': 'PER',
    'Surat Kuasa': 'KSA',
    'Surat Tugas': 'TGS',
    'Surat Rekomendasi': 'REK',
    'Surat Keterangan': 'KET',
    'Surat Izin': 'IZN',
    'Surat Undangan': 'UND',
    'Permohonan Dana': 'PD',
    'LPJ': 'LPJ',
  };

  late bool isEdit;
  late String nomor;
  late String tanggal;
  late String perihal;
  String? asal;
  String? tujuan;
  String? tipe;
  String? kategori;
  String? keterangan;

  final _nomorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEdit = widget.surat != null;

    final surat = widget.surat;
    if (isEdit && surat != null) {
      nomor = surat.nomor;
      tanggal = surat.tanggal;
      perihal = surat.perihal;
      asal = surat.asal;
      tujuan = surat.tujuan;
      tipe = surat.tipe;
      kategori = surat.kategori;
      keterangan = surat.keterangan;
      _nomorController.text = nomor;
    } else {
      tanggal = DateTime.now().toIso8601String().split('T').first;
      perihal = '';
      asal = '';
      tujuan = '';
      tipe = 'Pribadi';
      kategori = 'IZN';
      keterangan = '';
      nomor = '';
      if (!widget.isMasuk) _generateNomorKeluar();
    }
  }

  Future<void> _generateNomorKeluar() async {
    final last = await dao.getLastNomorSuratKeluar();
    final newNumber = last + 1;
    nomor = newNumber.toString().padLeft(3, '0');

    setState(() {
      _nomorController.text = nomor;
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final bulanRomawi = convertMonthToRoman(DateTime.parse(tanggal).month);
    final tahun = DateTime.parse(tanggal).year.toString();

    final surat = SuratModel(
      id: widget.surat?.id,
      nomor: nomor,
      isMasuk: widget.isMasuk,
      tanggal: tanggal,
      tipe: widget.isMasuk ? '' : tipe ?? '',
      kategori: widget.isMasuk ? '' : kategori ?? '',
      perihal: perihal,
      asal: widget.isMasuk ? asal : null,
      tujuan: widget.isMasuk ? null : tujuan,
      keterangan: widget.isMasuk ? null : keterangan,
      bulanRomawi: bulanRomawi,
      tahun: tahun,
    );

    if (isEdit) {
      await dao.updateSurat(surat);
    } else {
      await dao.insertSurat(surat);
    }

    if (context.mounted) Navigator.pop(context, true); // <- kirim "true"
  }

  @override
  Widget build(BuildContext context) {
    final isMasuk = widget.isMasuk;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Surat' : 'Tambah Surat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NOMOR
              isMasuk
                  ? TextFormField(
                    initialValue: nomor,
                    decoration: const InputDecoration(labelText: 'Nomor'),
                    onSaved: (val) => nomor = val ?? '',
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Nomor harus diisi'
                                : null,
                  )
                  : TextFormField(
                    controller: _nomorController,
                    readOnly: true,
                    enabled: false,
                    style: const TextStyle(color: Colors.black54),
                    decoration: InputDecoration(
                      labelText: 'Nomor',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
              const SizedBox(height: 8),

              // TANGGAL
              TextFormField(
                initialValue: tanggal,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (yyyy-MM-dd)',
                ),
                onSaved: (val) => tanggal = val ?? '',
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Tanggal harus diisi'
                            : null,
              ),
              const SizedBox(height: 8),

              // ASAL (jika masuk)
              if (isMasuk)
                TextFormField(
                  initialValue: asal,
                  decoration: const InputDecoration(labelText: 'Asal'),
                  onSaved: (val) => asal = val,
                )
              else ...[
                // TUJUAN
                TextFormField(
                  initialValue: tujuan,
                  decoration: const InputDecoration(labelText: 'Tujuan'),
                  onSaved: (val) => tujuan = val,
                ),
                const SizedBox(height: 8),

                // TIPE
                DropdownButtonFormField<String>(
                  value: tipe,
                  decoration: const InputDecoration(labelText: 'Tipe'),
                  items:
                      ['Pribadi', 'Bersama']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => tipe = val),
                  onSaved: (val) => tipe = val,
                ),
                const SizedBox(height: 8),

                // KATEGORI
                DropdownButtonFormField<String>(
                  value:
                      kategoriOptions.entries
                          .firstWhere(
                            (e) => e.value == kategori,
                            orElse: () => kategoriOptions.entries.first,
                          )
                          .key,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items:
                      kategoriOptions.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key, // yang ditampilkan user
                          child: Text(entry.key),
                        );
                      }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => kategori = kategoriOptions[val]!);
                    }
                  },
                  onSaved: (val) {
                    if (val != null) kategori = kategoriOptions[val]!;
                  },
                ),

                const SizedBox(height: 8),
              ],

              // PERIHAL
              TextFormField(
                initialValue: perihal,
                decoration: const InputDecoration(labelText: 'Perihal'),
                onSaved: (val) => perihal = val ?? '',
              ),

              // KETERANGAN (hanya keluar)
              if (!isMasuk)
                TextFormField(
                  initialValue: keterangan,
                  decoration: const InputDecoration(labelText: 'Keterangan'),
                  onSaved: (val) => keterangan = val,
                ),
              const SizedBox(height: 20),

              // SIMPAN
              ElevatedButton(onPressed: _save, child: const Text('SIMPAN')),
            ],
          ),
        ),
      ),
    );
  }
}
