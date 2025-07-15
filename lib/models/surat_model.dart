class SuratModel {
  final int? id;
  final String nomor;
  final bool isMasuk;
  final String tanggal;
  final String perihal;

  // Untuk surat masuk
  final String? asal;

  // Untuk surat keluar
  final String? tujuan;
  final String? tipe;
  final String? kategori;
  final String? keterangan;

  final String bulanRomawi;
  final String tahun;

  SuratModel({
    this.id,
    required this.nomor,
    required this.isMasuk,
    required this.tanggal,
    required this.perihal,
    this.asal,
    this.tujuan,
    this.tipe,
    this.kategori,
    this.keterangan,
    required this.bulanRomawi,
    required this.tahun,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomor': nomor,
      'isMasuk': isMasuk ? 1 : 0,
      'tanggal': tanggal,
      'perihal': perihal,
      'asal': asal,
      'tujuan': tujuan,
      'tipe': tipe,
      'kategori': kategori,
      'keterangan': keterangan,
      'bulanRomawi': bulanRomawi,
      'tahun': tahun,
    };
  }

  factory SuratModel.fromMap(Map<String, dynamic> map) {
    return SuratModel(
      id: map['id'],
      nomor: map['nomor'],
      isMasuk: map['isMasuk'] == 1,
      tanggal: map['tanggal'],
      perihal: map['perihal'],
      asal: map['asal'],
      tujuan: map['tujuan'],
      tipe: map['tipe'],
      kategori: map['kategori'],
      keterangan: map['keterangan'],
      bulanRomawi: map['bulanRomawi'],
      tahun: map['tahun'],
    );
  }

  SuratModel copyWith({
    int? id,
    String? nomor,
    bool? isMasuk,
    String? tanggal,
    String? perihal,
    String? asal,
    String? tujuan,
    String? tipe,
    String? kategori,
    String? keterangan,
    String? bulanRomawi,
    String? tahun,
  }) {
    return SuratModel(
      id: id ?? this.id,
      nomor: nomor ?? this.nomor,
      isMasuk: isMasuk ?? this.isMasuk,
      tanggal: tanggal ?? this.tanggal,
      perihal: perihal ?? this.perihal,
      asal: asal ?? this.asal,
      tujuan: tujuan ?? this.tujuan,
      tipe: tipe ?? this.tipe,
      kategori: kategori ?? this.kategori,
      keterangan: keterangan ?? this.keterangan,
      bulanRomawi: bulanRomawi ?? this.bulanRomawi,
      tahun: tahun ?? this.tahun,
    );
  }
}
