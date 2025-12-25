import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

/// SQLite veritabanı yönetimi için helper sınıfı
/// Singleton pattern kullanılarak tek instance oluşturulur
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Veritabanı instance'ını döndür, yoksa oluştur
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  /// Veritabanını başlat ve oluştur
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Veritabanı tablolarını oluştur
  Future _createDB(Database db, int version) async {
    // Kullanıcılar tablosu (Kişi 1 için)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Notlar tablosu (Kişi 2 için)
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Not ekleme (Create)
  Future<int> createNote(NoteModel note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  /// Tüm notları getir (Read All)
  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'updatedAt DESC');
    return result.map((json) => NoteModel.fromMap(json)).toList();
  }

  /// Belirli bir kullanıcının notlarını getir
  Future<List<NoteModel>> getNotesByUserId(int userId) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );
    return result.map((json) => NoteModel.fromMap(json)).toList();
  }

  /// Tek bir notu ID ile getir (Read)
  Future<NoteModel?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return NoteModel.fromMap(result.first);
  }

  /// Not güncelleme (Update)
  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// Not silme (Delete)
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Kullanıcı ekleme (Kişi 1 için yardımcı)
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  /// Email ile kullanıcı bulma (Login için)
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isEmpty) return null;
    return result.first;
  }

  /// Veritabanını kapat
  Future close() async {
    final db = await database;
    db.close();
  }
}
