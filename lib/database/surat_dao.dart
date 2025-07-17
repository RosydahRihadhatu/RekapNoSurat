import 'db_helper.dart';
import '../models/surat_model.dart';

class SuratDao {
  final dbHelper = DBHelper();

  Future<int> insertSurat(SuratModel surat) async {
    final db = await dbHelper.database;
    return await db.insert('surat', surat.toMap());
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

  Future<int> getLastNomorSuratKeluar() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
    SELECT nomor FROM surat 
    WHERE isMasuk = 0 
    ORDER BY CAST(SUBSTR(nomor, 1, 3) AS INTEGER) DESC 
    LIMIT 1
  ''');

    if (result.isEmpty) return 0;

    final lastNomor = result.first['nomor'] as String;
    final parts = lastNomor.split('/');
    return int.tryParse(parts[0]) ?? 0;
  }
}
