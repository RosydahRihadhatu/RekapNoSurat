import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() => _instance;

  static Database? _database;
  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'surat.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomor TEXT,
        isMasuk INTEGER,
        tanggal TEXT,
        tipe TEXT,
        kategori TEXT,
        perihal TEXT,
        asal TEXT,
        tujuan TEXT,
        keterangan TEXT,
        bulanRomawi TEXT,
        tahun TEXT
      )
    ''');
  }
}
