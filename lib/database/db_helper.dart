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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
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

    // Tambahkan tabel nomor_counter
    await db.execute('''
      CREATE TABLE nomor_counter (
        id INTEGER PRIMARY KEY,
        last_nomor INTEGER NOT NULL
      )
    ''');

    // Masukkan default counter awal = 0
    await db.insert('nomor_counter', {'id': 1, 'last_nomor': 0});
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tambah tabel nomor_counter jika belum ada
      await db.execute('''
        CREATE TABLE nomor_counter (
          id INTEGER PRIMARY KEY,
          last_nomor INTEGER NOT NULL
        )
      ''');
      await db.insert('nomor_counter', {'id': 1, 'last_nomor': 0});
    }
  }

  Future<int> getLastNomorSuratKeluar() async {
    final db = await database;
    final result = await db.query('nomor_counter', where: 'id = 1');
    if (result.isNotEmpty) {
      return result.first['last_nomor'] as int;
    }
    return 0;
  }

  Future<void> incrementNomorSuratKeluar() async {
    final db = await database;
    final last = await getLastNomorSuratKeluar();
    await db.update('nomor_counter', {'last_nomor': last + 1}, where: 'id = 1');
  }
}
