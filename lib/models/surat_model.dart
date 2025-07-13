class SuratModel {
  final int? id;
  final String nomor;
  final bool isMasuk;
  final String tanggal;
  final String tipe;
  final String kategori;
  final String perihal;
  final String? asal; // untuk surat masuk
  final String? tujuan; // untuk surat keluar
  final String? keterangan;
  final String bulanRomawi;
  final String tahun;

  SuratModel({
    this.id,
    required this.nomor,
    required this.isMasuk,
    required this.tanggal,
    required this.tipe,
    required this.kategori,
    required this.perihal,
    this.asal,
    this.tujuan,
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
      'tipe': tipe,
      'kategori': kategori,
      'perihal': perihal,
      'asal': asal,
      'tujuan': tujuan,
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
      tipe: map['tipe'],
      kategori: map['kategori'],
      perihal: map['perihal'],
      asal: map['asal'],
      tujuan: map['tujuan'],
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
    String? tipe,
    String? kategori,
    String? perihal,
    String? asal,
    String? tujuan,
    String? keterangan,
    String? bulanRomawi,
    String? tahun,
  }) {
    return SuratModel(
      id: id ?? this.id,
      nomor: nomor ?? this.nomor,
      isMasuk: isMasuk ?? this.isMasuk,
      tanggal: tanggal ?? this.tanggal,
      tipe: tipe ?? this.tipe,
      kategori: kategori ?? this.kategori,
      perihal: perihal ?? this.perihal,
      asal: asal ?? this.asal,
      tujuan: tujuan ?? this.tujuan,
      keterangan: keterangan ?? this.keterangan,
      bulanRomawi: bulanRomawi ?? this.bulanRomawi,
      tahun: tahun ?? this.tahun,
    );
  }
}
