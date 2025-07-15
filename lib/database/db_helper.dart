import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'surat.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomor TEXT NOT NULL,
        isMasuk INTEGER NOT NULL,
        tanggal TEXT NOT NULL,
        asal TEXT,
        tujuan TEXT,
        tipe TEXT,
        kategori TEXT,
        perihal TEXT NOT NULL,
        keterangan TEXT,
        bulanRomawi TEXT,
        tahun TEXT
      )
    ''');
  }
}
