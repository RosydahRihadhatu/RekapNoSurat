import 'db_helper.dart';
import '../models/surat_model.dart';

class SuratDao {
  final dbHelper = DBHelper();

  Future<int> insertSurat(SuratModel surat) async {
    final db = await dbHelper.database;
    final id = await db.insert('surat', surat.toMap());

    // Tambahkan counter jika surat keluar
    if (!surat.isMasuk) {
      await dbHelper.incrementNomorSuratKeluar();
    }

    return id;
  }

  Future<int> updateSurat(SuratModel surat) async {
    final db = await dbHelper.database;
    return await db.update(
      'surat',
      surat.toMap(),
      where: 'id = ?',
      whereArgs: [surat.id],
    );
  }

  Future<int> deleteSurat(int id) async {
    final db = await dbHelper.database;
    return await db.delete('surat', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<SuratModel>> getAllSurat() async {
    final db = await dbHelper.database;
    final maps = await db.query('surat', orderBy: 'id DESC');
    return maps.map((map) => SuratModel.fromMap(map)).toList();
  }

  /// Ambil counter nomor terakhir dari tabel `nomor_counter`
  Future<int> getLastNomorSuratKeluar() async {
    return await dbHelper.getLastNomorSuratKeluar();
  }
}
