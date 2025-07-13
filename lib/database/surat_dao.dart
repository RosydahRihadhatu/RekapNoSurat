import '../models/surat_model.dart';
import 'db_helper.dart';

class SuratDao {
  final dbHelper = DbHelper();

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
    final List<Map<String, dynamic>> result = await db.query(
      'surat',
      orderBy: 'id ASC',
    );
    return result.map((map) => SuratModel.fromMap(map)).toList();
  }

  Future<int> getLastKeluarNumber() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      "SELECT nomor FROM surat WHERE isMasuk = 0 ORDER BY id DESC LIMIT 1",
    );
    if (result.isNotEmpty) {
      final lastNomor = result.first['nomor'] as String;
      return int.tryParse(lastNomor) ?? 0;
    }
    return 0;
  }
}
