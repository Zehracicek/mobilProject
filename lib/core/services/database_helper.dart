import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static const String _dbName = 'notes.db';
  static const int _dbVersion = 1;
  static const String _tableNotes = 'notes';
  static const String _tableUsers = 'users';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);

      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
      );
    } catch (e) {
      throw Exception('Veritabanı başlatılırken hata: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableNotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_tableUsers (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertNote(NoteModel note) async {
    try {
      final db = await database;
      return await db.insert(_tableNotes, note.toMap());
    } catch (e) {
      throw Exception('insertNote hatası: $e');
    }
  }

  Future<List<NoteModel>> getAllNotes() async {
    try {
      final db = await database;
      final maps = await db.query(_tableNotes, orderBy: 'updatedAt DESC');
      return maps.map((m) => NoteModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('getAllNotes hatası: $e');
    }
  }

  Future<NoteModel?> getNoteById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) return NoteModel.fromMap(maps.first);
      return null;
    } catch (e) {
      throw Exception('getNoteById hatası: $e');
    }
  }

  Future<List<NoteModel>> getNotesByUserId(int userId) async {
    try {
      final db = await database;
      final result = await db.query(
        _tableNotes,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'updatedAt DESC',
      );
      return result.map((json) => NoteModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('getNotesByUserId hatası: $e');
    }
  }

  Future<int> updateNote(NoteModel note) async {
    try {
      final db = await database;
      return await db.update(
        _tableNotes,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      throw Exception('updateNote hatası: $e');
    }
  }

  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('deleteNote hatası: $e');
    }
  }

  Future<int> createUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert(_tableUsers, user);
    } catch (e) {
      throw Exception('createUser hatası: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final result = await db.query(
        _tableUsers,
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isEmpty) return null;
      return result.first;
    } catch (e) {
      throw Exception('getUserByEmail hatası: $e');
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      throw Exception('close hatası: $e');
    }
  }
}
