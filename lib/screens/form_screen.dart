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
    'Undangan': 'UND',
    'Izin': 'IZN',
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

    if (isEdit) {
      final surat = widget.surat!;
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
      kategori = 'UND';
      keterangan = '';
      nomor = '';

      if (!widget.isMasuk) {
        _generateNomorKeluar();
      }
    }
  }

  Future<void> _generateNomorKeluar() async {
    final last = await dao.getLastNomorSuratKeluar();
    final newNumber = last + 1;
    nomor = newNumber.toString().padLeft(3, '0');
    if (mounted) {
      setState(() {
        _nomorController.text = nomor;
      });
    }
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

    if (context.mounted) Navigator.pop(context, true);
  }

  Widget buildField(String label, Widget input) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: input),
        ],
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMasuk = widget.isMasuk;
    final backgroundColor =
        isMasuk ? const Color(0xFFFFF0F5) : const Color(0xFFE6F0FF);
    final simpanColor = isMasuk ? Colors.pink : Colors.blue;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          '${isEdit ? 'Ubah' : 'Tambah'} Surat ${widget.isMasuk ? 'Masuk' : 'Keluar'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(
                'Nomor',
                isMasuk
                    ? TextFormField(
                      initialValue: nomor,
                      decoration: inputDecoration(),
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
                      decoration: inputDecoration(),
                    ),
              ),
              buildField(
                'Tanggal',
                TextFormField(
                  initialValue: tanggal,
                  decoration: inputDecoration(),
                  onSaved: (val) => tanggal = val ?? '',
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Tanggal harus diisi'
                              : null,
                ),
              ),
              if (isMasuk)
                buildField(
                  'Asal',
                  TextFormField(
                    initialValue: asal,
                    decoration: inputDecoration(),
                    onSaved: (val) => asal = val,
                  ),
                )
              else ...[
                buildField(
                  'Tujuan',
                  TextFormField(
                    initialValue: tujuan,
                    decoration: inputDecoration(),
                    onSaved: (val) => tujuan = val,
                  ),
                ),
                buildField(
                  'Tipe',
                  DropdownButtonFormField<String>(
                    value: tipe,
                    decoration: inputDecoration(),
                    items:
                        ['Pribadi', 'Bersama']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => tipe = val),
                    onSaved: (val) => tipe = val,
                  ),
                ),
                buildField(
                  'Kategori',
                  DropdownButtonFormField<String>(
                    value:
                        kategoriOptions.entries
                            .firstWhere(
                              (e) => e.value == kategori,
                              orElse: () => kategoriOptions.entries.first,
                            )
                            .key,
                    decoration: inputDecoration(),
                    items:
                        kategoriOptions.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.key),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => kategori = kategoriOptions[val]!);
                      }
                    },
                    onSaved: (val) {
                      if (val != null) kategori = kategoriOptions[val]!;
                    },
                  ),
                ),
              ],
              buildField(
                'Perihal',
                TextFormField(
                  initialValue: perihal,
                  decoration: inputDecoration(),
                  onSaved: (val) => perihal = val ?? '',
                ),
              ),
              if (!isMasuk)
                buildField(
                  'Keterangan',
                  TextFormField(
                    initialValue: keterangan,
                    maxLines: 4,
                    decoration: inputDecoration(),
                    onSaved: (val) => keterangan = val,
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: simpanColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _save,
                  child: const Text('SIMPAN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
