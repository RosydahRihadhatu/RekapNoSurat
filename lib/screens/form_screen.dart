import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/surat_dao.dart';
import '../models/surat_model.dart';

class FormScreen extends StatefulWidget {
  final bool isMasuk;
  final SuratModel? surat;
  const FormScreen({super.key, required this.isMasuk, this.surat});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final SuratDao suratDao = SuratDao();

  late TextEditingController nomorController;
  late TextEditingController tanggalController;
  late TextEditingController perihalController;
  late TextEditingController asalController;
  late TextEditingController tujuanController;
  late TextEditingController keteranganController;
  String tipe = '';
  String kategori = '';

  final List<String> tipeOptions = ['Pribadi', 'Bersama'];
  final List<String> kategoriOptions = ['IZN', 'LPJ', 'UND', 'KET'];

  @override
  void initState() {
    super.initState();
    final s = widget.surat;
    nomorController = TextEditingController(text: s?.nomor ?? '');
    tanggalController = TextEditingController(text: s?.tanggal ?? '');
    perihalController = TextEditingController(text: s?.perihal ?? '');
    asalController = TextEditingController(text: s?.asal ?? '');
    tujuanController = TextEditingController(text: s?.tujuan ?? '');
    keteranganController = TextEditingController(text: s?.keterangan ?? '');
    tipe = s?.tipe ?? '';
    kategori = s?.kategori ?? '';

    if (!widget.isMasuk && s == null) {
      _generateNomorKeluar();
    }
  }

  Future<void> _generateNomorKeluar() async {
    final last = await suratDao.getLastKeluarNumber();
    final nomor = (last + 1).toString().padLeft(3, '0');
    nomorController.text = nomor;
  }

  String _getRomawi(String bulan) {
    const romawi = [
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII',
    ];
    return romawi[int.parse(bulan) - 1];
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final date = DateTime.parse(tanggalController.text);
      final bulan = DateFormat('MM').format(date);
      final tahun = date.year.toString();

      final model = SuratModel(
        id: widget.surat?.id,
        nomor: nomorController.text,
        isMasuk: widget.isMasuk,
        tanggal: tanggalController.text,
        tipe: tipe,
        kategori: kategori,
        perihal: perihalController.text,
        asal: widget.isMasuk ? asalController.text : null,
        tujuan: widget.isMasuk ? null : tujuanController.text,
        keterangan: keteranganController.text,
        bulanRomawi: _getRomawi(bulan),
        tahun: tahun,
      );

      if (widget.surat == null) {
        await suratDao.insertSurat(model);
      } else {
        await suratDao.updateSurat(model);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMasuk ? 'Surat Masuk' : 'Surat Keluar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomorController,
                enabled: widget.isMasuk,
                decoration: const InputDecoration(labelText: 'Nomor'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: tanggalController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (yyyy-MM-dd)',
                ),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: perihalController,
                decoration: const InputDecoration(labelText: 'Perihal'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField(
                value: tipe.isNotEmpty ? tipe : null,
                items:
                    tipeOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => tipe = val!),
                decoration: const InputDecoration(labelText: 'Tipe'),
              ),
              DropdownButtonFormField(
                value: kategori.isNotEmpty ? kategori : null,
                items:
                    kategoriOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => kategori = val!),
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              widget.isMasuk
                  ? TextFormField(
                    controller: asalController,
                    decoration: const InputDecoration(labelText: 'Asal Surat'),
                  )
                  : TextFormField(
                    controller: tujuanController,
                    decoration: const InputDecoration(
                      labelText: 'Tujuan Surat',
                    ),
                  ),
              TextFormField(
                controller: keteranganController,
                decoration: const InputDecoration(labelText: 'Keterangan'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _simpan, child: const Text('SIMPAN')),
            ],
          ),
        ),
      ),
    );
  }
}
