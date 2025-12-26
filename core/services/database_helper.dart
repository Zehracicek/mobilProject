import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';

    // Users tablosu
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType UNIQUE,
        password $textType,
        createdAt $textType
      )
    ''');

    // Notes tablosu
    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        userId $textType,
        title $textType,
        content $textTypeNullable,
        category $textType,
        createdAt $textType,
        updatedAt $textType
      )
    ''');
  }

  // ============ USER İŞLEMLERİ ============

  Future<int> createUser(UserModel user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // ============ NOTE İŞLEMLERİ ============

  // Not ekle
  Future<int> createNote(NoteModel note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  // Kullanıcının tüm notlarını getir
  Future<List<NoteModel>> getUserNotes(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );

    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Kategoriye göre notları getir
  Future<List<NoteModel>> getNotesByCategory(
    String userId,
    String category,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'userId = ? AND category = ?',
      whereArgs: [userId, category],
      orderBy: 'updatedAt DESC',
    );

    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Not güncelle
  Future<int> updateNote(NoteModel note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Not sil
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Not ara
  Future<List<NoteModel>> searchNotes(String userId, String query) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'userId = ? AND (title LIKE ? OR content LIKE ?)',
      whereArgs: [userId, '%$query%', '%$query%'],
      orderBy: 'updatedAt DESC',
    );

    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Compatibility wrapper methods used by services
  Future<List<NoteModel>> getNotesByUserId(int userId) async {
    return getUserNotes(userId.toString());
  }

  Future<int> insertNote(NoteModel note) async {
    return createNote(note);
  }

  Future<NoteModel?> getNoteById(int id) async {
    final db = await instance.database;
    final maps = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return NoteModel.fromMap(maps.first);
    return null;
  }

  // Veritabanını kapat
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
