import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('riwayat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE riwayat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        jenis_kelamin TEXT,
        tanggal_lahir TEXT,
        umur_bulan INTEGER,
        tinggi REAL,
        berat REAL,
        status_bbtb TEXT,
        status_tbu TEXT,
        kesimpulan TEXT,
        metode TEXT,
        tanggal_periksa TEXT
      )
    ''');
  }

  Future<int> insertRiwayat(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('riwayat', data);
  }

  Future<List<Map<String, dynamic>>> getAllRiwayat() async {
    final db = await database;
    return await db.query('riwayat', orderBy: 'tanggal_periksa DESC');
  }

  Future<int> deleteRiwayat(int id) async {
    final db = await database;
    return await db.delete('riwayat', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllRiwayat() async {
    final db = await database;
    return await db.delete('riwayat');
  }
}
